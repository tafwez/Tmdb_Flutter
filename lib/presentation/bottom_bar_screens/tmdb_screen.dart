import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_app/core/theme/app_colors.dart';
import 'package:tmdb_app/core/theme/app_dimensions.dart';

import '../../core/cubits/auth/auth_cubit.dart';
import '../../core/cubits/auth/auth_state.dart';
import '../../core/theme/theme_cubit.dart';

class TmdbScreen extends StatelessWidget {
  const TmdbScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Quick theme toggle button
          IconButton(
            icon: Icon(
              context.read<ThemeCubit>().isDarkMode(context)
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: const Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        const SizedBox(height: AppDimensions.spaceLG),
                        Text(
                          'Dummy User',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: AppDimensions.spaceSM),
                        Text(
                          '@Dummy',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  // Settings Section
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingLG,
                            vertical: AppDimensions.paddingSM,
                          ),
                          child: Text(
                            'THEME SETTINGS',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        // Theme Options
                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, themeState) {
                            return Column(
                              children: [
                                // Light Mode
                                Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: AppDimensions.marginXS,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.light_mode),
                                    title: const Text('Light Mode'),
                                    subtitle: const Text('Use light theme'),
                                    trailing: Radio<ThemeMode>(
                                      value: ThemeMode.light,
                                      groupValue: themeState.themeMode,
                                      onChanged: (value) {
                                        context.read<ThemeCubit>().setLightTheme();
                                      },
                                    ),
                                    onTap: () {
                                      context.read<ThemeCubit>().setLightTheme();
                                    },
                                  ),
                                ),

                                // Dark Mode
                                Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: AppDimensions.marginXS,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.dark_mode),
                                    title: const Text('Dark Mode'),
                                    subtitle: const Text('Use dark theme'),
                                    trailing: Radio<ThemeMode>(
                                      value: ThemeMode.dark,
                                      groupValue: themeState.themeMode,
                                      onChanged: (value) {
                                        context.read<ThemeCubit>().setDarkTheme();
                                      },
                                    ),
                                    onTap: () {
                                      context.read<ThemeCubit>().setDarkTheme();
                                    },
                                  ),
                                ),

                                // System Default
                                Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: AppDimensions.marginXS,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.settings_system_daydream),
                                    title: const Text('System Default'),
                                    subtitle: const Text('Follow system theme'),
                                    trailing: Radio<ThemeMode>(
                                      value: ThemeMode.system,
                                      groupValue: themeState.themeMode,
                                      onChanged: (value) {
                                        context.read<ThemeCubit>().setSystemTheme();
                                      },
                                    ),
                                    onTap: () {
                                      context.read<ThemeCubit>().setSystemTheme();
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: AppDimensions.spaceXL),

                        // Other Settings Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingLG,
                            vertical: AppDimensions.paddingSM,
                          ),
                          child: Text(
                            'ACCOUNT',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        // Account Settings (You can add more options here)
                        Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: AppDimensions.marginXS,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('Edit Profile'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate to edit profile
                            },
                          ),
                        ),

                        Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: AppDimensions.marginXS,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.notifications),
                            title: const Text('Notifications'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate to notifications settings
                            },
                          ),
                        ),

                        Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: AppDimensions.marginXS,
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.language),
                            title: const Text('Language'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate to language settings
                            },
                          ),
                        ),

                        const SizedBox(height: AppDimensions.spaceXL),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Show confirmation dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                    'Are you sure you want to logout?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => context.pop(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        context.pop(); // Close dialog
                                        context.read<AuthCubit>().logout();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingLG,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusSM,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}