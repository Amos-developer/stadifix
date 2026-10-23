package com.stadifix.api.provider.api;

import com.stadifix.api.provider.dto.ProviderProfileRequest;
import com.stadifix.api.provider.dto.ProviderProfileResponse;
import com.stadifix.api.provider.service.ProviderProfileService;

import jakarta.validation.Valid;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/providers")
public class ProviderController {

    private final ProviderProfileService profileService;

    public ProviderController(
            ProviderProfileService profileService
    ) {
        this.profileService = profileService;
    }

    @PostMapping("/me/profile")
    public ResponseEntity<ProviderProfileResponse> createProfile(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody ProviderProfileRequest request
    ) {
        UUID userId = UUID.fromString(jwt.getSubject());

        ProviderProfileResponse response =
                profileService.create(userId, request);

        return ResponseEntity
                .created(URI.create(
                        "/api/v1/providers/" + response.providerId()
                ))
                .body(response);
    }

    @GetMapping("/me/profile")
    public ProviderProfileResponse getMyProfile(
            @AuthenticationPrincipal Jwt jwt
    ) {
        UUID userId = UUID.fromString(jwt.getSubject());

        return profileService.getById(userId);
    }

    @PutMapping("/me/profile")
    public ProviderProfileResponse updateMyProfile(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody ProviderProfileRequest request
    ) {
        UUID userId = UUID.fromString(jwt.getSubject());

        return profileService.update(userId, request);
    }

    @GetMapping("/{providerId}")
    public ProviderProfileResponse getPublicProfile(
            @PathVariable UUID providerId
    ) {
        return profileService.getById(providerId);
    }
}
