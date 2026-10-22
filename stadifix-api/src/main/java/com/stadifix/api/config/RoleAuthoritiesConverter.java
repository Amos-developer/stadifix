package com.stadifix.api.config;

import com.stadifix.api.user.domain.AppUser;
import com.stadifix.api.user.repository.UserRepository;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.OAuth2Error;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Component
public class RoleAuthoritiesConverter
        implements Converter<Jwt, Collection<GrantedAuthority>> {

    private final UserRepository userRepository;

    public RoleAuthoritiesConverter(
            UserRepository userRepository
    ) {
        this.userRepository = userRepository;
    }

    @Override
    public Collection<GrantedAuthority> convert(Jwt jwt) {

        UUID userId;

        try {
            userId = UUID.fromString(jwt.getSubject());
        } catch (IllegalArgumentException | NullPointerException ex) {
            throw invalidAccount();
        }

        AppUser user = userRepository.findById(userId)
                .orElseThrow(this::invalidAccount);

        String authority = "ROLE_" + user.getRole().name();

        return List.of(
                new SimpleGrantedAuthority(authority)
        );
    }

    private OAuth2AuthenticationException invalidAccount() {
        return new OAuth2AuthenticationException(
                new OAuth2Error(
                        "invalid_token",
                        "Invalid or unavailable user account",
                        null
                )
        );
    }
}
