package com.stadifix.api.provider.domain;

import com.stadifix.api.user.domain.AppUser;
import jakarta.persistence.*;

import java.util.UUID;

@Entity
@Table(name = "provider_profiles")
public class ProviderProfile {

    @Id
    @Column(name = "user_id")
    private UUID userId;

    @OneToOne(
            fetch = FetchType.LAZY,
            optional = false
    )
    @MapsId
    @JoinColumn(name = "user_id")
    private AppUser user;

    @Column(
            name = "display_name",
            nullable = false,
            length = 120
    )
    private String displayName;

    @Column(name = "bio", length = 500)
    private String bio;

    @Column(
            name = "service_area",
            nullable = false,
            length = 120
    )
    private String serviceArea;

    protected ProviderProfile() {
        // Required by JPA
    }

    public ProviderProfile(
            AppUser user,
            String displayName,
            String bio,
            String serviceArea
    ) {
        this.user = user;
        this.displayName = displayName;
        this.bio = bio;
        this.serviceArea = serviceArea;
    }

    public UUID getUserId() {
        return userId;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getBio() {
        return bio;
    }

    public String getServiceArea() {
        return serviceArea;
    }

    public void update(
            String displayName,
            String bio,
            String serviceArea
    ) {
        this.displayName = displayName;
        this.bio = bio;
        this.serviceArea = serviceArea;
    }
}
