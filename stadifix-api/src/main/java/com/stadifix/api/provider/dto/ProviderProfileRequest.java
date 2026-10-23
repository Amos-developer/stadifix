package com.stadifix.api.provider.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record ProviderProfileRequest(

        @NotBlank
        @Size(max = 120)
        String displayName,

        @Size(max = 500)
        String bio,

        @NotBlank
        @Size(max = 120)
        String serviceArea

) {}
