package com.stadifix.api.booking.dto;

import com.stadifix.api.booking.domain.BookingStatus;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record BookingResponse(
        UUID id,
        UUID serviceId,
        String serviceTitle,
        UUID providerId,
        String providerName,
        UUID customerId,
        Instant scheduledFor,
        String serviceAddress,
        String customerNotes,
        BigDecimal quotedPrice,
        String currency,
        BookingStatus status,
        Instant createdAt
) {}
