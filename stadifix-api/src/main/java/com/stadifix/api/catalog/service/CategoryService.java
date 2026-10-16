package com.stadifix.api.catalog.service;

import com.stadifix.api.catalog.dto.ServiceCategoryResponse;
import com.stadifix.api.catalog.repository.ServiceCategoryRepository;

import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class CategoryService {

    private final ServiceCategoryRepository repository;

    public CategoryService(
            ServiceCategoryRepository repository
    ) {
        this.repository = repository;
    }

    @Transactional(readOnly = true)
    public List<ServiceCategoryResponse> getAllCategories() {

        return repository.findAll(
                        Sort.by(
                                Sort.Direction.ASC,
                                "name"
                        )
                ).stream()
                .map(category -> new ServiceCategoryResponse(
                        category.getId(),
                        category.getName(),
                        category.getDescription()
                ))
                .toList();
    }
}
