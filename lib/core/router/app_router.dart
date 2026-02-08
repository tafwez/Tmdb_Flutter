import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/presentation/bottom_bar_screens/movies_screen.dart';
import 'package:tmdb_app/presentation/bottom_bar_screens/celebrities_screen.dart';
import 'package:tmdb_app/presentation/sub_screens/movie_details.dart';
import 'package:tmdb_app/presentation/sub_screens/tv_see_all.dart';
import '../../presentation/bottom_bar_screens/search_screen.dart';
import '../../presentation/bottom_bar_screens/tmdb_screen.dart';
import '../../presentation/bottom_bar_screens/tvshows_screen.dart';
import '../../presentation/main_screens/error_screen.dart';
import '../../presentation/main_screens/home_screen.dart';
import '../../presentation/main_screens/login_screen.dart';
import '../../presentation/main_screens/splash_screen.dart';
import '../../presentation/sub_screens/movie_see_all.dart';
import '../../presentation/sub_screens/tv_detail.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/bottom_nav/BottomNavCubit.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final isAuthenticated = authCubit.isAuthenticated;
      final isOnSplash = state.matchedLocation == '/splash';
      final isLoggingIn = state.matchedLocation == '/login';

      if (isOnSplash) {
        return null;
      }

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/movies';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BlocProvider(
            create: (_) => BottomNavCubit(),
            child: HomeScreen(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/movies',
                name: 'movies',
                builder: (context, state) => const MoviesScreen(),
                routes: [
                  GoRoute(
                    path: 'movie_see_all',
                    name: 'movies_see_all',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return SeeAll(
                        title: extra?['title'] ?? 'See All',
                        category: extra?['category'] ?? '',
                        mediaType: extra?['mediaType'] ?? 'main_cubit',
                      );
                    },
                  ),
                  GoRoute(
                    path: 'movie_details',
                    name: 'movie_details',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return MovieDetails(
                        id: extra?['id'] ?? '0',
                        title: extra?['title']?? 'title'
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tvshows',
                name: 'tvshows',
                builder: (context, state) => const TvshowsScreen(),
                routes: [
                  GoRoute(
                    path: 'tv_see_all',
                    name: 'tv_see_all',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return TvSeeAll(
                        title: extra?['title'] ?? 'See All',
                        category: extra?['category'] ?? '',
                        mediaType: extra?['mediaType'] ?? 'tv',
                      );
                    },
                  ),
                  GoRoute(
                    path: 'tv_details',
                    name: 'tv_details',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>?;
                      return TvDetails(
                          id: extra?['id'] ?? '0',
                          title: extra?['title']?? 'title'
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/celebrities',
                name: 'celebrities',
                builder: (context, state) => const CelebritiesScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tmdb',
                name: 'tmdb',
                builder: (context, state) => const TmdbScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(path: '/', redirect: (context, state) => '/splash'),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
