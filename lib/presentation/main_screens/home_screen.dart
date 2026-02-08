import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/cubits/auth/auth_cubit.dart';
import '../../core/cubits/auth/auth_state.dart';
import '../../core/cubits/bottom_nav/BottomNavCubit.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_cubit.dart';


class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  String _getTitleFromRoute(String location) {
    if (location.startsWith('/movies')) return 'Movies';
    if (location.startsWith('/tvshows')) return 'TV Shows';
    if (location.startsWith('/celebrities')) return 'Celebrities';
    if (location.startsWith('/search')) return 'Search';
    if (location.startsWith('/tmdb')) return 'TMDB';
    return 'TMDB App';
  }

  bool _shouldShowAppBar(String location) {
    return !location.contains('/movie_see_all') && !location.contains('/tv_see_all') && !location.contains('/movie_details') && !location.contains("/tv_details");
  }

  // ✅ Check if we're on a main page
  bool _isMainPage(String location) {
    final mainRoutes = ['/movies', '/tvshows', '/celebrities', '/search', '/tmdb'];
    return mainRoutes.contains(location);
  }

  void _onItemTapped(BuildContext context, int index) {
    context.read<BottomNavCubit>().changeTab(index);

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentRoute = GoRouterState.of(context).uri.toString();
    final showAppBar = _shouldShowAppBar(currentRoute);
    final currentIndex = navigationShell.currentIndex;
    final isMainPage = _isMainPage(currentRoute);

    // ✅ PopScope add karo for back button handling
    return PopScope(
      canPop: isMainPage, // Main page pe hi app close hoga
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // ✅ Sub-page se hai to pop karo
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        // ✅ Conditionally show AppBar
        appBar: showAppBar
            ? AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
          elevation: 0,
          iconTheme: IconThemeData(
            color: isDark ? AppColors.darkIconPrimary : AppColors.lightIconPrimary,
          ),
          title: Text(_getTitleFromRoute(currentRoute)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
            ),
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
        )
            : null,

        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            if (authState is! AuthAuthenticated) {
              return const Center(child: CircularProgressIndicator());
            }

            // ✅ Display the current branch/tab with its navigation stack preserved
            return navigationShell;
          },
        ),

        // ✅ Bottom Navigation Bar
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => _onItemTapped(context, index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.local_movies_outlined),
              selectedIcon: Icon(Icons.local_movies),
              label: "Movies",
            ),
            NavigationDestination(
              icon: Icon(Icons.tv_outlined),
              selectedIcon: Icon(Icons.tv),
              label: "TV Shows",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: "Celebrities",
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined),
              selectedIcon: Icon(Icons.search),
              label: "Search",
            ),
            NavigationDestination(
              icon: Icon(Icons.reorder_outlined),
              selectedIcon: Icon(Icons.reorder),
              label: "TMDB",
            ),
          ],
        ),
      ),
    );
  }
}