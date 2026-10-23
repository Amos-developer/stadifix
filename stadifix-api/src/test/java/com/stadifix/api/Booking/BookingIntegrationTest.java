package com.stadifix.api.Booking;

import com.jayway.jsonpath.JsonPath;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.dao.DataIntegrityViolationException;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.RequestPostProcessor;

import org.testcontainers.postgresql.PostgreSQLContainer;

import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
class BookingIntegrationTest {

    static final PostgreSQLContainer postgres =
            new PostgreSQLContainer("postgres:17-alpine")
                    .withDatabaseName("stadifix_test")
                    .withUsername("stadifix_test")
                    .withPassword("test_password");

    static {
        postgres.start();
    }

    @DynamicPropertySource
    static void configureDatabase(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);

        registry.add("STADIFIX_DB_PASSWORD", postgres::getPassword);

        // Test-only secret; never use for real tokens.
        registry.add("stadifix.jwt.secret",
                () -> Base64.getEncoder().encodeToString(
                        "stadifix-integration-test-secret-1234567890"
                                .getBytes(StandardCharsets.UTF_8)));
    }

    @Autowired
    MockMvc mvc;

    @Autowired
    JdbcTemplate jdbc;

    UUID customerId;
    UUID providerId;
    UUID otherProviderId;
    UUID serviceId;

    Instant appointment;

    @BeforeEach
    void setUp() {
        customerId = UUID.randomUUID();
        providerId = UUID.randomUUID();
        otherProviderId = UUID.randomUUID();
        serviceId = UUID.randomUUID();

        appointment = Instant.now()
                .plus(7, ChronoUnit.DAYS)
                .truncatedTo(ChronoUnit.SECONDS);

        insertUser(customerId, "CUSTOMER");
        insertUser(providerId, "PROVIDER");
        insertUser(otherProviderId, "PROVIDER");

        insertProviderProfile(providerId, "Juma Electrical");
        insertProviderProfile(otherProviderId, "Other Provider");

        UUID categoryId = jdbc.queryForObject(
                "SELECT id FROM service_categories ORDER BY name LIMIT 1",
                UUID.class
        );

        jdbc.update("""
            INSERT INTO services (
                id,
                provider_id,
                category_id,
                title,
                description,
                starting_price
            )
            VALUES (?, ?, ?, ?, ?, ?)
            """,
                serviceId,
                providerId,
                categoryId,
                "Electrical Repair",
                "Residential electrical repair service",
                new BigDecimal("25000.00")
        );
    }

    @Test
    void customerCanCreateBooking() throws Exception {
        UUID bookingId = createBooking();

        BigDecimal price = jdbc.queryForObject(
                "SELECT quoted_price FROM bookings WHERE id = ?",
                BigDecimal.class,
                bookingId
        );

        assertThat(price).isEqualByComparingTo("25000.00");
    }

    @Test
    void unauthenticatedUserCannotCreateBooking() throws Exception {
        mvc.perform(
                        post("/api/v1/bookings")
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(bookingJson())
                )
                .andExpect(status().isUnauthorized());
    }

    @Test
    void providerCannotCreateCustomerBooking() throws Exception {
        mvc.perform(
                        post("/api/v1/bookings")
                                .with(asRole(providerId, "PROVIDER"))
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(bookingJson())
                )
                .andExpect(status().isForbidden());
    }

    @Test
    void customerCannotAcceptBooking() throws Exception {
        UUID bookingId = createBooking();

        mvc.perform(
                        patch("/api/v1/bookings/{id}/accept", bookingId)
                                .with(asRole(customerId, "CUSTOMER"))
                )
                .andExpect(status().isForbidden());
    }

    @Test
    void providerCanAcceptAndCompleteBooking() throws Exception {
        UUID bookingId = createBooking();

        mvc.perform(
                        patch("/api/v1/bookings/{id}/accept", bookingId)
                                .with(asRole(providerId, "PROVIDER"))
                )
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("ACCEPTED"));

        mvc.perform(
                        patch("/api/v1/bookings/{id}/complete", bookingId)
                                .with(asRole(providerId, "PROVIDER"))
                )
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("COMPLETED"));

        // Completed bookings cannot be accepted again.
        mvc.perform(
                        patch("/api/v1/bookings/{id}/accept", bookingId)
                                .with(asRole(providerId, "PROVIDER"))
                )
                .andExpect(status().isConflict());
    }

    @Test
    void anotherProviderCannotAcceptBooking() throws Exception {
        UUID bookingId = createBooking();

        mvc.perform(
                        patch("/api/v1/bookings/{id}/accept", bookingId)
                                .with(asRole(otherProviderId, "PROVIDER"))
                )
                .andExpect(status().isNotFound());
    }

    @Test
    void providerCannotAcceptTwoBookingsForSameSlot() throws Exception {
        UUID firstBooking = createBooking();
        UUID secondBooking = createBooking();

        mvc.perform(
                        patch("/api/v1/bookings/{id}/accept", firstBooking)
                                .with(asRole(providerId, "PROVIDER"))
                )
                .andExpect(status().isOk());

        mvc.perform(
                        patch("/api/v1/bookings/{id}/accept", secondBooking)
                                .with(asRole(providerId, "PROVIDER"))
                )
                .andExpect(status().isConflict());

        // Verify PostgreSQL itself enforces the slot constraint.
        assertThatThrownBy(() ->
                jdbc.update(
                        "UPDATE bookings SET status = 'ACCEPTED' WHERE id = ?",
                        secondBooking
                )
        ).isInstanceOf(DataIntegrityViolationException.class);
    }

    private UUID createBooking() throws Exception {
        String response = mvc.perform(
                        post("/api/v1/bookings")
                                .with(asRole(customerId, "CUSTOMER"))
                                .contentType(MediaType.APPLICATION_JSON)
                                .content(bookingJson())
                )
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status").value("REQUESTED"))
                .andExpect(jsonPath("$.currency").value("TZS"))
                .andReturn()
                .getResponse()
                .getContentAsString();

        String id = JsonPath.read(response, "$.id");

        return UUID.fromString(id);
    }

    private String bookingJson() {
        return """
            {
              "serviceId": "%s",
              "scheduledFor": "%s",
              "serviceAddress": "Mbezi Beach, Dar es Salaam",
              "customerNotes": "Please check the wiring."
            }
            """.formatted(serviceId, appointment);
    }

    private RequestPostProcessor asRole(UUID userId, String role) {
        return jwt()
                .jwt(builder ->
                        builder.claim("sub", userId.toString())
                )
                .authorities(
                        new SimpleGrantedAuthority("ROLE_" + role)
                );
    }

    private void insertUser(UUID id, String role) {
        jdbc.update("""
            INSERT INTO users (
                id,
                full_name,
                email,
                password_hash,
                role
            )
            VALUES (?, ?, ?, ?, ?)
            """,
                id,
                "Integration Test User",
                "test-" + id + "@example.test",
                "{noop}unused-test-password",
                role
        );
    }

    private void insertProviderProfile(
            UUID userId,
            String displayName
    ) {
        jdbc.update("""
            INSERT INTO provider_profiles (
                user_id,
                display_name,
                bio,
                service_area
            )
            VALUES (?, ?, ?, ?)
            """,
                userId,
                displayName,
                "Test provider",
                "Dar es Salaam"
        );
    }
}
