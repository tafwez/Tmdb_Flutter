// lib/presentation/cubits/theme/theme_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme State
class ThemeState {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

// Theme Cubit
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.system)) {
    _loadTheme();
  }

  // Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt(_themeKey) ?? 0;

      final themeMode = ThemeMode.values[themeModeIndex];
      emit(state.copyWith(themeMode: themeMode));
    } catch (e) {
      // If error, use system default
      emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }

  // Save theme to SharedPreferences
  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  // Change theme
  void changeTheme(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
    _saveTheme(themeMode);
  }

  // Toggle between light and dark
  void toggleTheme() {
    final newTheme = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    changeTheme(newTheme);
  }

  // Set light theme
  void setLightTheme() {
    changeTheme(ThemeMode.light);
  }

  // Set dark theme
  void setDarkTheme() {
    changeTheme(ThemeMode.dark);
  }

  // Set system theme
  void setSystemTheme() {
    changeTheme(ThemeMode.system);
  }

  // Check if current theme is dark
  bool isDarkMode(BuildContext context) {
    if (state.themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return state.themeMode == ThemeMode.dark;
  }
}