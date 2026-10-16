package com.stadifix.api.catalog.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record ServiceSummaryResponse(
        UUID id,
        String title,
        String category,
        BigDecimal startingPrice,
        String currency
) {}
