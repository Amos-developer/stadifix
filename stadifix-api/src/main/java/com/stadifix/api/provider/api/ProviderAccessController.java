package com.stadifix.api.provider.api;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/v1/providers/me")
public class ProviderAccessController {

    @GetMapping("/access")
    public Map<String, String> checkAccess(
            @AuthenticationPrincipal Jwt jwt
    ) {
        return Map.of(
                "message", "Provider access granted",
                "userId", jwt.getSubject()
        );
    }
}
