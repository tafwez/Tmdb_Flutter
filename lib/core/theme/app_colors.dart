// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ==================== LIGHT MODE COLORS ====================

  // Primary Colors - Light Mode
  static const Color lightPrimary = Color(0xFF1E88E5); // Blue
  static const Color lightPrimaryVariant = Color(0xFF1565C0);
  static const Color lightSecondary = Color(0xFF26A69A); // Teal
  static const Color lightSecondaryVariant = Color(0xFF00897B);

  // Background Colors - Light Mode
  static const Color lightBackground = Color(0xFFFFFFFF); // White
  static const Color lightSurface = Color(0xFFF5F5F5); // Light Gray
  static const Color lightCard = Color(0xFFFFFFFF);

  // Text Colors - Light Mode
  static const Color lightTextPrimary = Color(0xFF212121); // Almost Black
  static const Color lightTextSecondary = Color(0xFF757575); // Gray
  static const Color lightTextHint = Color(0xFFBDBDBD); // Light Gray

  // Border & Divider - Light Mode
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightDivider = Color(0xFFEEEEEE);

  // Icon Colors - Light Mode
  static const Color lightIconPrimary = Color(0xFF212121);
  static const Color lightIconSecondary = Color(0xFF757575);

  // ==================== DARK MODE COLORS ====================

  // Primary Colors - Dark Mode
  static const Color darkPrimary = Color(0xFF42A5F5); // Lighter Blue
  static const Color darkPrimaryVariant = Color(0xFF1E88E5);
  static const Color darkSecondary = Color(0xFF4DB6AC); // Lighter Teal
  static const Color darkSecondaryVariant = Color(0xFF26A69A);

  // Background Colors - Dark Mode
  static const Color darkBackground = Color(0xFF121212); // Almost Black
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark Gray
  static const Color darkCard = Color(0xFF2C2C2C); // Card Background

  // Text Colors - Dark Mode
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // White
  static const Color darkTextSecondary = Color(0xFFB0B0B0); // Light Gray
  static const Color darkTextHint = Color(0xFF6B6B6B); // Gray

  // Border & Divider - Dark Mode
  static const Color darkBorder = Color(0xFF3A3A3A);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // Icon Colors - Dark Mode
  static const Color darkIconPrimary = Color(0xFFFFFFFF);
  static const Color darkIconSecondary = Color(0xFFB0B0B0);

  // ==================== COMMON COLORS ====================

  // Status Colors (Same for both modes)
  static const Color success = Color(0xFF4CAF50); // Green
  static const Color error = Color(0xFFF44336); // Red
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color info = Color(0xFF2196F3); // Blue

  // Rating Star
  static const Color ratingStarFilled = Color(0xFFFFD700); // Gold
  static const Color ratingStarEmpty = Color(0xFFBDBDBD); // Gray

  // Shimmer Effect - Light Mode
  static const Color lightShimmerBase = Color(0xFFE0E0E0);
  static const Color lightShimmerHighlight = Color(0xFFF5F5F5);

  // Shimmer Effect - Dark Mode
  static const Color darkShimmerBase = Color(0xFF2C2C2C);
  static const Color darkShimmerHighlight = Color(0xFF3A3A3A);

  // Overlay Colors
  static const Color lightOverlay = Color(0x1F000000); // 12% Black
  static const Color darkOverlay = Color(0x3DFFFFFF); // 24% White

  // Movie Card Gradient - Light Mode
  static const List<Color> lightCardGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFF5F5F5),
  ];

  // Movie Card Gradient - Dark Mode
  static const List<Color> darkCardGradient = [
    Color(0xFF2C2C2C),
    Color(0xFF1E1E1E),
  ];
}
