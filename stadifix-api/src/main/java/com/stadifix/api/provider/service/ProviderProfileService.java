package com.stadifix.api.provider.service;

import com.stadifix.api.provider.domain.ProviderProfile;
import com.stadifix.api.provider.dto.ProviderProfileRequest;
import com.stadifix.api.provider.dto.ProviderProfileResponse;
import com.stadifix.api.provider.repository.ProviderProfileRepository;
import com.stadifix.api.user.domain.AppUser;
import com.stadifix.api.user.domain.UserRole;
import com.stadifix.api.user.repository.UserRepository;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.UUID;

@Service
public class ProviderProfileService {

    private final ProviderProfileRepository profileRepository;
    private final UserRepository userRepository;

    public ProviderProfileService(
            ProviderProfileRepository profileRepository,
            UserRepository userRepository
    ) {
        this.profileRepository = profileRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public ProviderProfileResponse create(
            UUID userId,
            ProviderProfileRequest request
    ) {
        AppUser user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "User account unavailable"
                ));

        if (user.getRole() != UserRole.PROVIDER) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Only providers can create profiles"
            );
        }

        if (profileRepository.existsById(userId)) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Provider profile already exists"
            );
        }

        ProviderProfile profile = new ProviderProfile(
                user,
                request.displayName().trim(),
                normalizeBio(request.bio()),
                request.serviceArea().trim()
        );

        ProviderProfile saved =
                profileRepository.saveAndFlush(profile);

        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public ProviderProfileResponse getById(UUID providerId) {
        return toResponse(findProfile(providerId));
    }

    @Transactional
    public ProviderProfileResponse update(
            UUID userId,
            ProviderProfileRequest request
    ) {
        ProviderProfile profile = findProfile(userId);

        profile.update(
                request.displayName().trim(),
                normalizeBio(request.bio()),
                request.serviceArea().trim()
        );

        return toResponse(profile);
    }

    private ProviderProfile findProfile(UUID id) {
        return profileRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Provider profile not found"
                ));
    }

    private String normalizeBio(String bio) {
        if (bio == null || bio.isBlank()) {
            return null;
        }

        return bio.trim();
    }

    private ProviderProfileResponse toResponse(
            ProviderProfile profile
    ) {
        return new ProviderProfileResponse(
                profile.getUserId(),
                profile.getDisplayName(),
                profile.getBio(),
                profile.getServiceArea()
        );
    }
}
