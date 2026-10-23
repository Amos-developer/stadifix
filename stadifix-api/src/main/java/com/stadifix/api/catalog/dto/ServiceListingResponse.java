package com.stadifix.api.catalog.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record ServiceListingResponse(
        UUID id,
        UUID providerId,
        String providerName,
        UUID categoryId,
        String categoryName,
        String title,
        String description,
        BigDecimal startingPrice,
        String currency,
        boolean active
) {}
