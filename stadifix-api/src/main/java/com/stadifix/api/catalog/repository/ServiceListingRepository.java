package com.stadifix.api.catalog.repository;

import com.stadifix.api.catalog.domain.ServiceListing;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ServiceListingRepository
        extends JpaRepository<ServiceListing, UUID> {

    @EntityGraph(attributePaths = {"provider", "category"})
    Page<ServiceListing> findByActiveTrue(Pageable pageable);

    @EntityGraph(attributePaths = {"provider", "category"})
    Page<ServiceListing> findByActiveTrueAndCategory_Id(
            UUID categoryId,
            Pageable pageable
    );

    @EntityGraph(attributePaths = {"provider", "category"})
    Page<ServiceListing> findByProvider_UserId(
            UUID providerId,
            Pageable pageable
    );
}
