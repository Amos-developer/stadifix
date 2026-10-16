package com.stadifix.api.catalog.repository;

import com.stadifix.api.catalog.domain.ServiceCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ServiceCategoryRepository
        extends JpaRepository<ServiceCategory, UUID> {
}
