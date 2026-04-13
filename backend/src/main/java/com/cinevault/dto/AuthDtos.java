package com.cinevault.dto;

import java.util.UUID;

public class AuthDtos {

    public record RegisterRequest(
            String email,
            String username,
            String password,
            String displayName,
            UUID sessionId
    ) {}

    public record LoginRequest(
            String email,
            String password,
            UUID sessionId
    ) {}

    public record RefreshRequest(
            String refreshToken
    ) {}

    public record AuthResponse(
            UserDto user,
            String accessToken,
            String refreshToken
    ) {}

    public record UserDto(
            Long id,
            String email,
            String username,
            String displayName,
            String role
    ) {}
}
