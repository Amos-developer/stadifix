package com.stadifix.api.user.dto;

import com.stadifix.api.user.domain.UserRole;
import java.util.UUID;

public record UserProfileResponse(
        UUID id,
        String fullName,
        String email,
        UserRole role
) {}
