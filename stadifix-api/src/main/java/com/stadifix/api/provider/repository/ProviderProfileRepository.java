package com.stadifix.api.provider.repository;

import com.stadifix.api.provider.domain.ProviderProfile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ProviderProfileRepository
        extends JpaRepository<ProviderProfile, UUID> {
}
