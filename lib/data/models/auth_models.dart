import 'package:equatable/equatable.dart';

class RequestTokenResponse {
  final bool success;
  final String requestToken;
  final String expiresAt;

  RequestTokenResponse({
    required this.success,
    required this.requestToken,
    required this.expiresAt,
  });

  factory RequestTokenResponse.fromJson(Map<String, dynamic> json) {
    return RequestTokenResponse(
      success: json['success'] ?? false,
      requestToken: json['request_token'] ?? '',
      expiresAt: json['expires_at'] ?? '',
    );
  }
}

class SessionResponse {
  final bool success;
  final String sessionId;

  SessionResponse({
    required this.success,
    required this.sessionId,
  });

  factory SessionResponse.fromJson(Map<String, dynamic> json) {
    return SessionResponse(
      success: json['success'] ?? false,
      sessionId: json['session_id'] ?? '',
    );
  }
}

class UserDetails {
  final int id;
  final String username;
  final String name;
  final String avatarPath;

  UserDetails({
    required this.id,
    required this.username,
    required this.name,
    required this.avatarPath,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      avatarPath: json['avatar']?['tmdb']?['avatar_path'] ?? '',
    );
  }
}