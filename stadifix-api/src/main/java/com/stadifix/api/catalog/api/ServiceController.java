package com.stadifix.api.catalog.api;

import com.stadifix.api.catalog.dto.*;
import com.stadifix.api.catalog.service.ServiceCatalogService;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.UUID;

@Validated
@RestController
@RequestMapping("/api/v1/services")
public class ServiceController {

    private final ServiceCatalogService serviceCatalog;

    public ServiceController(
            ServiceCatalogService serviceCatalog
    ) {
        this.serviceCatalog = serviceCatalog;
    }

    @GetMapping
    public PagedResponse<ServiceListingResponse> browse(
            @RequestParam(required = false) UUID categoryId,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10")
            @Min(1) @Max(50) int size
    ) {
        return serviceCatalog.browse(categoryId, page, size);
    }

    @GetMapping("/{serviceId}")
    public ServiceListingResponse getById(
            @PathVariable UUID serviceId
    ) {
        return serviceCatalog.getPublic(serviceId);
    }

    @PostMapping
    public ResponseEntity<ServiceListingResponse> create(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody ServiceListingRequest request
    ) {
        ServiceListingResponse response = serviceCatalog.create(
                UUID.fromString(jwt.getSubject()),
                request
        );

        return ResponseEntity
                .created(URI.create(
                        "/api/v1/services/" + response.id()
                ))
                .body(response);
    }

    @PutMapping("/{serviceId}")
    public ServiceListingResponse update(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID serviceId,
            @Valid @RequestBody ServiceListingRequest request
    ) {
        return serviceCatalog.update(
                UUID.fromString(jwt.getSubject()),
                serviceId,
                request
        );
    }

    @PatchMapping("/{serviceId}/deactivate")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deactivate(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID serviceId
    ) {
        serviceCatalog.deactivate(
                UUID.fromString(jwt.getSubject()),
                serviceId
        );
    }
}
