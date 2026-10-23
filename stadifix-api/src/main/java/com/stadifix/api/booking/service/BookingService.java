package com.stadifix.api.booking.service;

import com.stadifix.api.booking.domain.*;
import com.stadifix.api.booking.dto.*;
import com.stadifix.api.booking.repository.BookingRepository;

import com.stadifix.api.catalog.domain.ServiceListing;
import com.stadifix.api.catalog.repository.ServiceListingRepository;
import com.stadifix.api.catalog.dto.PagedResponse;

import com.stadifix.api.user.domain.AppUser;
import com.stadifix.api.user.repository.UserRepository;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final ServiceListingRepository serviceRepository;
    private final UserRepository userRepository;

    public BookingService(
            BookingRepository bookingRepository,
            ServiceListingRepository serviceRepository,
            UserRepository userRepository
    ) {
        this.bookingRepository = bookingRepository;
        this.serviceRepository = serviceRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public BookingResponse request(
            UUID customerId,
            BookingRequest request
    ) {
        AppUser customer = userRepository.findById(customerId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.UNAUTHORIZED,
                        "Account unavailable"
                ));

        ServiceListing service = serviceRepository
                .findById(request.serviceId())
                .filter(ServiceListing::isActive)
                .orElseThrow(this::notFound);

        Booking booking = new Booking(
                service,
                customer,
                request.scheduledFor(),
                request.serviceAddress().trim(),
                normalizeNotes(request.customerNotes())
        );

        return toResponse(
                bookingRepository.saveAndFlush(booking)
        );
    }

    @Transactional(readOnly = true)
    public PagedResponse<BookingResponse> customerBookings(
            UUID customerId,
            int page,
            int size
    ) {
        return PagedResponse.from(
                bookingRepository.findByCustomer_Id(
                        customerId,
                        pagination(page, size)
                ).map(this::toResponse)
        );
    }

    @Transactional(readOnly = true)
    public PagedResponse<BookingResponse> providerBookings(
            UUID providerId,
            int page,
            int size
    ) {
        return PagedResponse.from(
                bookingRepository.findByProvider_UserId(
                        providerId,
                        pagination(page, size)
                ).map(this::toResponse)
        );
    }

    @Transactional
    public BookingResponse accept(
            UUID providerId,
            UUID bookingId
    ) {
        Booking booking = ownedByProvider(providerId, bookingId);
        requireStatus(booking, BookingStatus.REQUESTED);

        if (!booking.getScheduledFor().isAfter(Instant.now())) {
            throw conflict("Appointment time has passed");
        }

        boolean slotTaken = bookingRepository
                .existsByProvider_UserIdAndScheduledForAndStatusIn(
                        providerId,
                        booking.getScheduledFor(),
                        List.of(
                                BookingStatus.ACCEPTED,
                                BookingStatus.COMPLETED
                        )
                );

        if (slotTaken) {
            throw conflict("Appointment slot is unavailable");
        }

        booking.changeStatus(BookingStatus.ACCEPTED);

        // Forces database constraints to be checked now.
        bookingRepository.flush();

        return toResponse(booking);
    }

    @Transactional
    public BookingResponse decline(
            UUID providerId,
            UUID bookingId
    ) {
        Booking booking = ownedByProvider(providerId, bookingId);
        requireStatus(booking, BookingStatus.REQUESTED);

        booking.changeStatus(BookingStatus.DECLINED);

        return toResponse(booking);
    }

    @Transactional
    public BookingResponse complete(
            UUID providerId,
            UUID bookingId
    ) {
        Booking booking = ownedByProvider(providerId, bookingId);
        requireStatus(booking, BookingStatus.ACCEPTED);

        booking.changeStatus(BookingStatus.COMPLETED);

        return toResponse(booking);
    }

    @Transactional
    public BookingResponse cancel(
            UUID customerId,
            UUID bookingId
    ) {
        Booking booking = bookingRepository
                .findLockedById(bookingId)
                .orElseThrow(this::notFound);

        if (!booking.getCustomer().getId().equals(customerId)) {
            throw notFound();
        }

        requireStatus(booking, BookingStatus.REQUESTED);
        booking.changeStatus(BookingStatus.CANCELLED);

        return toResponse(booking);
    }

    private Booking ownedByProvider(
            UUID providerId,
            UUID bookingId
    ) {
        Booking booking = bookingRepository
                .findLockedById(bookingId)
                .orElseThrow(this::notFound);

        if (!booking.getProvider().getUserId()
                .equals(providerId)) {
            throw notFound();
        }

        return booking;
    }

    private void requireStatus(
            Booking booking,
            BookingStatus required
    ) {
        if (booking.getStatus() != required) {
            throw conflict(
                    "Invalid booking status transition"
            );
        }
    }

    private String normalizeNotes(String notes) {
        return notes == null || notes.isBlank()
                ? null
                : notes.trim();
    }

    private PageRequest pagination(int page, int size) {
        return PageRequest.of(
                page,
                size,
                Sort.by(Sort.Direction.DESC, "createdAt")
                        .and(Sort.by("id"))
        );
    }

    private BookingResponse toResponse(Booking booking) {
        return new BookingResponse(
                booking.getId(),
                booking.getService().getId(),
                booking.getService().getTitle(),
                booking.getProvider().getUserId(),
                booking.getProvider().getDisplayName(),
                booking.getCustomer().getId(),
                booking.getScheduledFor(),
                booking.getServiceAddress(),
                booking.getCustomerNotes(),
                booking.getQuotedPrice(),
                booking.getCurrency(),
                booking.getStatus(),
                booking.getCreatedAt()
        );
    }

    private ResponseStatusException notFound() {
        return new ResponseStatusException(
                HttpStatus.NOT_FOUND,
                "Booking or service not found"
        );
    }

    private ResponseStatusException conflict(String message) {
        return new ResponseStatusException(
                HttpStatus.CONFLICT,
                message
        );
    }
}
