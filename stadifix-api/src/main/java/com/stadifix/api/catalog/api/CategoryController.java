package com.stadifix.api.catalog.api;

import com.stadifix.api.catalog.dto.ServiceCategoryResponse;
import com.stadifix.api.catalog.service.CategoryService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("api/v1/categories")
public class CategoryController{
    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public List<ServiceCategoryResponse> getCategories() {
        return categoryService.getAllCategories();
    }
}
