package com.stadifix.api.auth.dto;

import com.stadifix.api.user.domain.UserRole;
import jakarta.validation.constraints.*;

public record RegisterRequest(

        @NotBlank
        @Size(min = 2, max = 120)
        String fullName,

        @NotBlank
        @Email
        @Size(max = 254)
        String email,

        @NotBlank
        @Size(min = 12, max = 72)
        String password,

        @NotNull
        UserRole role
) {}
