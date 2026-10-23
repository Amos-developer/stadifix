package com.stadifix.api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;

import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;

import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return PasswordEncoderFactories
                .createDelegatingPasswordEncoder();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter(
            RoleAuthoritiesConverter roleConverter
    ) {
        JwtAuthenticationConverter converter =
                new JwtAuthenticationConverter();

        converter.setJwtGrantedAuthoritiesConverter(
                roleConverter
        );

        return converter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            JwtAuthenticationConverter jwtConverter
    ) throws Exception {

        http
                .csrf(AbstractHttpConfigurer::disable)

                .sessionManagement(session ->
                        session.sessionCreationPolicy(
                                SessionCreationPolicy.STATELESS
                        )
                )

                .httpBasic(AbstractHttpConfigurer::disable)
                .formLogin(AbstractHttpConfigurer::disable)

                .authorizeHttpRequests(auth -> auth

                                // Public authentication
                                .requestMatchers(
                                        HttpMethod.POST,
                                        "/api/v1/auth/register",
                                        "/api/v1/auth/login"
                                ).permitAll()

                                // Public service discovery
                                .requestMatchers(
                                        HttpMethod.GET,
                                        "/api/v1/categories",
                                        "/api/v1/ping",
                                        "/api/v1/services",
                                        "/api/v1/services/{serviceId}"
                                ).permitAll()

                                // Public provider profiles
                                .requestMatchers(
                                        HttpMethod.GET,
                                        "/api/v1/providers/{providerId}"
                                ).permitAll()

                                // Provider-only service management
                                .requestMatchers(
                                        HttpMethod.POST,
                                        "/api/v1/services"
                                ).hasRole("PROVIDER")

                                .requestMatchers(
                                        HttpMethod.PUT,
                                        "/api/v1/services/{serviceId}"
                                ).hasRole("PROVIDER")

                                .requestMatchers(
                                        HttpMethod.PATCH,
                                        "/api/v1/services/{serviceId}/deactivate"
                                ).hasRole("PROVIDER")

                                // Provider management
                                .requestMatchers(
                                        "/api/v1/providers/me/**"
                                ).hasRole("PROVIDER")

                                // Current account
                                .requestMatchers(
                                        HttpMethod.GET,
                                        "/api/v1/users/me"
                                ).authenticated()

                                // Future customer endpoints
                                .requestMatchers(
                                        "/api/v1/customers/me/**"
                                ).hasRole("CUSTOMER")


                                // Customer booking operations
                                .requestMatchers(
                                        HttpMethod.POST,
                                        "/api/v1/bookings"
                                ).hasRole("CUSTOMER")

                                .requestMatchers(
                                        HttpMethod.GET,
                                        "/api/v1/bookings"
                                ).hasRole("CUSTOMER")

                                .requestMatchers(
                                        HttpMethod.PATCH,
                                        "/api/v1/bookings/{bookingId}/cancel"
                                ).hasRole("CUSTOMER")

                                // Provider booking operations
                                .requestMatchers(
                                        HttpMethod.GET,
                                        "/api/v1/providers/me/bookings"
                                ).hasRole("PROVIDER")

                                .requestMatchers(
                                        HttpMethod.PATCH,
                                        "/api/v1/bookings/{bookingId}/accept",
                                        "/api/v1/bookings/{bookingId}/decline",
                                        "/api/v1/bookings/{bookingId}/complete"
                                ).hasRole("PROVIDER")

                                .anyRequest().denyAll()
                )

                .oauth2ResourceServer(oauth2 ->
                        oauth2.jwt(jwt ->
                                jwt.jwtAuthenticationConverter(jwtConverter)
                        )
                );

        return http.build();
    }
}
