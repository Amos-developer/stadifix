package com.stadifix.api.catalog.domain;

import com.stadifix.api.provider.domain.ProviderProfile;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "services")
public class ServiceListing {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "provider_id", nullable = false)
    private ProviderProfile provider;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private ServiceCategory category;

    @Column(nullable = false, length = 120)
    private String title;

    @Column(nullable = false, length = 1000)
    private String description;

    @Column(
            name = "starting_price",
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal startingPrice;

    @Column(nullable = false, length = 3)
    private String currency = "TZS";

    @Column(name = "is_active", nullable = false)
    private boolean active = true;

    @Column(
            name = "created_at",
            insertable = false,
            updatable = false
    )
    private Instant createdAt;

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();

    protected ServiceListing() {}

    public ServiceListing(
            ProviderProfile provider,
            ServiceCategory category,
            String title,
            String description,
            BigDecimal startingPrice
    ) {
        this.provider = provider;
        this.category = category;
        this.title = title;
        this.description = description;
        this.startingPrice = startingPrice;
    }

    @PreUpdate
    public void beforeUpdate() {
        updatedAt = Instant.now();
    }

    public void updateDetails(
            ServiceCategory category,
            String title,
            String description,
            BigDecimal startingPrice
    ) {
        this.category = category;
        this.title = title;
        this.description = description;
        this.startingPrice = startingPrice;
    }

    public void deactivate() {
        this.active = false;
    }

    public UUID getId() { return id; }

    public ProviderProfile getProvider() { return provider; }

    public ServiceCategory getCategory() { return category; }

    public String getTitle() { return title; }

    public String getDescription() { return description; }

    public BigDecimal getStartingPrice() {
        return startingPrice;
    }

    public String getCurrency() { return currency; }

    public boolean isActive() { return active; }
}
