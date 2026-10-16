
package com.stadifix.api.catalog.api;

import com.stadifix.api.catalog.dto.ServiceSummaryResponse;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/services")
public class ServiceController {

    @GetMapping
    public List<ServiceSummaryResponse> getServices() {
        return List.of(
                new ServiceSummaryResponse(
                        UUID.fromString(
                                "00000000-0000-0000-0000-000000000001"
                        ),
                        "Electrical Repair",
                        "Electrical",
                        new BigDecimal("25000"),
                        "TZS"
                ),
                new ServiceSummaryResponse(
                        UUID.fromString(
                                "00000000-0000-0000-0000-000000000002"
                        ),
                        "Plumbing Services",
                        "Plumbing",
                        new BigDecimal("30000"),
                        "TZS"
                )
        );
    }
}
