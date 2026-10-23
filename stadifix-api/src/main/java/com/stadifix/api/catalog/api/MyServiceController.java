package com.stadifix.api.catalog.api;

import com.stadifix.api.catalog.dto.*;
import com.stadifix.api.catalog.service.ServiceCatalogService;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@Validated
@RestController
@RequestMapping("/api/v1/providers/me/services")
public class MyServiceController {

    private final ServiceCatalogService serviceCatalog;

    public MyServiceController(
            ServiceCatalogService serviceCatalog
    ) {
        this.serviceCatalog = serviceCatalog;
    }

    @GetMapping
    public PagedResponse<ServiceListingResponse> getMine(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10")
            @Min(1) @Max(50) int size
    ) {
        UUID userId = UUID.fromString(jwt.getSubject());

        return serviceCatalog.getMine(userId, page, size);
    }
}
