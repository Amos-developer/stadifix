package com.stadifix.api.booking.api;

import com.stadifix.api.booking.dto.BookingResponse;
import com.stadifix.api.booking.service.BookingService;
import com.stadifix.api.catalog.dto.PagedResponse;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@Validated
@RestController
@RequestMapping("/api/v1/providers/me/bookings")
public class ProviderBookingController {

    private final BookingService bookingService;

    public ProviderBookingController(
            BookingService bookingService
    ) {
        this.bookingService = bookingService;
    }

    @GetMapping
    public PagedResponse<BookingResponse> myBookings(
            @AuthenticationPrincipal Jwt jwt,
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "10")
            @Min(1) @Max(50) int size
    ) {
        return bookingService.providerBookings(
                UUID.fromString(jwt.getSubject()),
                page,
                size
        );
    }
}
