package com.stadifix.api.booking.api;

import com.stadifix.api.booking.dto.*;
import com.stadifix.api.booking.service.BookingService;
import com.stadifix.api.catalog.dto.PagedResponse;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.UUID;

@Validated
@RestController
@RequestMapping("/api/v1/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping
    public ResponseEntity<BookingResponse> request(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody BookingRequest request
    ) {
        BookingResponse response = bookingService.request(
                UUID.fromString(jwt.getSubject()),
                request
        );

        return ResponseEntity
                .created(URI.create(
                        "/api/v1/bookings/" + response.id()
                ))
                .body(response);
    }

    @GetMapping
    public PagedResponse<BookingResponse> myBookings(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10")
            @Min(1) @Max(50) int size
    ) {
        return bookingService.customerBookings(
                UUID.fromString(jwt.getSubject()),
                page,
                size
        );
    }

    @PatchMapping("/{bookingId}/cancel")
    public BookingResponse cancel(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID bookingId
    ) {
        return bookingService.cancel(
                UUID.fromString(jwt.getSubject()),
                bookingId
        );
    }

    @PatchMapping("/{bookingId}/accept")
    public BookingResponse accept(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID bookingId
    ) {
        return bookingService.accept(
                UUID.fromString(jwt.getSubject()),
                bookingId
        );
    }

    @PatchMapping("/{bookingId}/decline")
    public BookingResponse decline(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID bookingId
    ) {
        return bookingService.decline(
                UUID.fromString(jwt.getSubject()),
                bookingId
        );
    }

    @PatchMapping("/{bookingId}/complete")
    public BookingResponse complete(
            @AuthenticationPrincipal Jwt jwt,
            @PathVariable UUID bookingId
    ) {
        return bookingService.complete(
                UUID.fromString(jwt.getSubject()),
                bookingId
        );
    }
}
