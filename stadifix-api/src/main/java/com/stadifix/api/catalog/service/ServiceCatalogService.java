package com.stadifix.api.catalog.service;

import com.stadifix.api.catalog.domain.ServiceCategory;
import com.stadifix.api.catalog.domain.ServiceListing;
import com.stadifix.api.catalog.dto.*;
import com.stadifix.api.catalog.repository.*;

import com.stadifix.api.provider.domain.ProviderProfile;
import com.stadifix.api.provider.repository.ProviderProfileRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.UUID;

@Service
public class ServiceCatalogService {

    private final ServiceListingRepository listingRepository;
    private final ServiceCategoryRepository categoryRepository;
    private final ProviderProfileRepository providerRepository;

    public ServiceCatalogService(
            ServiceListingRepository listingRepository,
            ServiceCategoryRepository categoryRepository,
            ProviderProfileRepository providerRepository
    ) {
        this.listingRepository = listingRepository;
        this.categoryRepository = categoryRepository;
        this.providerRepository = providerRepository;
    }

    @Transactional
    public ServiceListingResponse create(
            UUID userId,
            ServiceListingRequest request
    ) {
        ProviderProfile provider = providerRepository
                .findById(userId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        "Create your provider profile first"
                ));

        ServiceCategory category =
                findCategory(request.categoryId());

        ServiceListing listing = new ServiceListing(
                provider,
                category,
                request.title().trim(),
                request.description().trim(),
                request.startingPrice()
        );

        return toResponse(
                listingRepository.saveAndFlush(listing)
        );
    }

    @Transactional(readOnly = true)
    public PagedResponse<ServiceListingResponse> browse(
            UUID categoryId,
            int page,
            int size
    ) {
        PageRequest pageable = pagination(page, size);

        Page<ServiceListing> result = categoryId == null
                ? listingRepository.findByActiveTrue(pageable)
                : listingRepository.findByActiveTrueAndCategory_Id(
                categoryId, pageable
        );

        return PagedResponse.from(
                result.map(this::toResponse)
        );
    }

    @Transactional(readOnly = true)
    public ServiceListingResponse getPublic(UUID serviceId) {
        ServiceListing listing = listingRepository
                .findById(serviceId)
                .filter(ServiceListing::isActive)
                .orElseThrow(this::serviceNotFound);

        return toResponse(listing);
    }

    @Transactional(readOnly = true)
    public PagedResponse<ServiceListingResponse> getMine(
            UUID userId,
            int page,
            int size
    ) {
        Page<ServiceListing> result =
                listingRepository.findByProvider_UserId(
                        userId,
                        pagination(page, size)
                );

        return PagedResponse.from(
                result.map(this::toResponse)
        );
    }

    @Transactional
    public ServiceListingResponse update(
            UUID userId,
            UUID serviceId,
            ServiceListingRequest request
    ) {
        ServiceListing listing = findOwned(userId, serviceId);

        ServiceCategory category =
                findCategory(request.categoryId());

        listing.updateDetails(
                category,
                request.title().trim(),
                request.description().trim(),
                request.startingPrice()
        );

        return toResponse(listing);
    }

    @Transactional
    public void deactivate(UUID userId, UUID serviceId) {
        ServiceListing listing = findOwned(userId, serviceId);
        listing.deactivate();
    }

    private ServiceListing findOwned(
            UUID userId,
            UUID serviceId
    ) {
        ServiceListing listing = listingRepository
                .findById(serviceId)
                .orElseThrow(this::serviceNotFound);

        if (!listing.getProvider().getUserId().equals(userId)) {
            throw serviceNotFound();
        }

        return listing;
    }

    private ServiceCategory findCategory(UUID categoryId) {
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Service category not found"
                ));
    }

    private ResponseStatusException serviceNotFound() {
        return new ResponseStatusException(
                HttpStatus.NOT_FOUND,
                "Service not found"
        );
    }

    private PageRequest pagination(int page, int size) {
        return PageRequest.of(
                page,
                size,
                Sort.by(Sort.Direction.DESC, "createdAt")
                        .and(Sort.by("id"))
        );
    }

    private ServiceListingResponse toResponse(
            ServiceListing listing
    ) {
        return new ServiceListingResponse(
                listing.getId(),
                listing.getProvider().getUserId(),
                listing.getProvider().getDisplayName(),
                listing.getCategory().getId(),
                listing.getCategory().getName(),
                listing.getTitle(),
                listing.getDescription(),
                listing.getStartingPrice(),
                listing.getCurrency(),
                listing.isActive()
        );
    }
}
