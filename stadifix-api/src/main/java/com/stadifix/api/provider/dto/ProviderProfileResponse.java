package com.stadifix.api.provider.dto;

import java.util.UUID;

public record ProviderProfileResponse(
        UUID providerId,
        String displayName,
        String bio,
        String serviceArea
) {}
