package com.stadifix.api.catalog.dto;

import jakarta.validation.constraints.*;

import java.math.BigDecimal;
import java.util.UUID;

public record ServiceListingRequest(

        @NotBlank
        @Size(max = 120)
        String title,

        @NotBlank
        @Size(max = 1000)
        String description,

        @NotNull
        UUID categoryId,

        @NotNull
        @DecimalMin("0.01")
        @Digits(integer = 10, fraction = 2)
        BigDecimal startingPrice

) {}
