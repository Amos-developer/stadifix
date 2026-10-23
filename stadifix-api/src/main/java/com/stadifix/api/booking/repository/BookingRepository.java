package com.stadifix.api.booking.repository;

import com.stadifix.api.booking.domain.Booking;
import com.stadifix.api.booking.domain.BookingStatus;

import jakarta.persistence.LockModeType;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.Collection;
import java.util.Optional;
import java.util.UUID;

public interface BookingRepository
        extends JpaRepository<Booking, UUID> {

    @EntityGraph(attributePaths = {"service", "provider"})
    Page<Booking> findByCustomer_Id(
            UUID customerId,
            Pageable pageable
    );

    @EntityGraph(attributePaths = {"service", "provider"})
    Page<Booking> findByProvider_UserId(
            UUID providerId,
            Pageable pageable
    );

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT b FROM Booking b WHERE b.id = :id")
    Optional<Booking> findLockedById(
            @Param("id") UUID id
    );

    boolean existsByProvider_UserIdAndScheduledForAndStatusIn(
            UUID providerId,
            Instant scheduledFor,
            Collection<BookingStatus> statuses
    );
}
