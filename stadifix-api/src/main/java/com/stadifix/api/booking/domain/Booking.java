package com.stadifix.api.booking.domain;

import com.stadifix.api.catalog.domain.ServiceListing;
import com.stadifix.api.provider.domain.ProviderProfile;
import com.stadifix.api.user.domain.AppUser;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "bookings")
public class Booking {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "service_id", nullable = false)
    private ServiceListing service;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "provider_id", nullable = false)
    private ProviderProfile provider;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "customer_id", nullable = false)
    private AppUser customer;

    @Column(name = "scheduled_for", nullable = false)
    private Instant scheduledFor;

    @Column(
            name = "service_address",
            nullable = false,
            length = 255
    )
    private String serviceAddress;

    @Column(name = "customer_notes", length = 1000)
    private String customerNotes;

    @Column(
            name = "quoted_price",
            nullable = false,
            precision = 12,
            scale = 2
    )
    private BigDecimal quotedPrice;

    @Column(nullable = false, length = 3)
    private String currency;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private BookingStatus status = BookingStatus.REQUESTED;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt = Instant.now();

    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt = Instant.now();

    protected Booking() {}

    public Booking(
            ServiceListing service,
            AppUser customer,
            Instant scheduledFor,
            String serviceAddress,
            String customerNotes
    ) {
        this.service = service;
        this.provider = service.getProvider();
        this.customer = customer;
        this.scheduledFor = scheduledFor;
        this.serviceAddress = serviceAddress;
        this.customerNotes = customerNotes;
        this.quotedPrice = service.getStartingPrice();
        this.currency = service.getCurrency();
    }

    @PreUpdate
    void updateTimestamp() {
        updatedAt = Instant.now();
    }

    public void changeStatus(BookingStatus nextStatus) {
        this.status = nextStatus;
    }

    public UUID getId() { return id; }
    public ServiceListing getService() { return service; }
    public ProviderProfile getProvider() { return provider; }
    public AppUser getCustomer() { return customer; }
    public Instant getScheduledFor() { return scheduledFor; }
    public String getServiceAddress() { return serviceAddress; }
    public String getCustomerNotes() { return customerNotes; }
    public BigDecimal getQuotedPrice() { return quotedPrice; }
    public String getCurrency() { return currency; }
    public BookingStatus getStatus() { return status; }
    public Instant getCreatedAt() { return createdAt; }
}
