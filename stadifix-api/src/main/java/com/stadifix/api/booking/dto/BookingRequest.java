package com.stadifix.api.booking.dto;

import jakarta.validation.constraints.*;

import java.time.Instant;
import java.util.UUID;

public record BookingRequest(

        @NotNull
        UUID serviceId,

        @NotNull
        @Future
        Instant scheduledFor,

        @NotBlank
        @Size(max = 255)
        String serviceAddress,

        @Size(max = 1000)
        String customerNotes

) {}
