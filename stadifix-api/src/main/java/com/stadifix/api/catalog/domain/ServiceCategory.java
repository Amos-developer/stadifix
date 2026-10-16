package com.stadifix.api.catalog.domain;

import jakarta.persistence.*;
import java.util.UUID;

@Entity
@Table(name = "service_categories")
public class ServiceCategory {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(
            name = "name",
            nullable = false,
            unique = true,
            length = 80
    )
    private String name;

    @Column(name = "description", length = 255)
    private String description;

    protected ServiceCategory() {
        // Required by JPA
    }

    public ServiceCategory(
            String name,
            String description
    ) {
        this.name = name;
        this.description = description;
    }

    public UUID getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }
}
