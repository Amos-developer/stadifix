package com.stadifix.api.auth.dto;

import com.stadifix.api.user.domain.UserRole;
import java.util.UUID;

public record RegisterResponse(
        UUID id,
        String fullName,
        String email,
        UserRole role
) {}
