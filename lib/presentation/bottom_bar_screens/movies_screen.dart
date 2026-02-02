// presentation/main_screens/movies_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/data/models/movie_model.dart';
import '../../core/cubits/main_cubit/main_cubit.dart';
import '../../core/cubits/main_cubit/state.dart';
import '../../core/helper/service_locator.dart';
import '../../data/genres/genres.dart';
import '../widgets/movie_Item.dart';
import '../widgets/now_playing_item.dart';
import '../widgets/toprated_items.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late final MainCubit _trendingCubit;
  late final MainCubit _popularCubit;
  late final MainCubit _nowPlayingCubit;
  late final MainCubit _topRatedCubit;
  late final MainCubit _upcomingCubit;
  late final MainCubit _genresCubit;

  @override
  void initState() {
    super.initState();
    _genresCubit = getIt<MainCubit>()..getMovieGenres();
    _trendingCubit = getIt<MainCubit>()..getTrendingMovies();
    _popularCubit = getIt<MainCubit>()..getPopularMovies(page: 1);
    _nowPlayingCubit = getIt<MainCubit>()..getNowPlayingMovies();
    _topRatedCubit = getIt<MainCubit>()..getTopRatedMovies();
    _upcomingCubit = getIt<MainCubit>()..getUpcomingMovies();
  }

  List<MediaItemModel> _getMediaItems(ApiState<dynamic> state) {
    if (state is ApiLoaded<MovieModel>) {
      return state.data.results
          .map((m) => MediaItemModel.fromMovieResult(m))
          .toList();
    }
    return [];
  }

  List<GenreModel> _getGenres(ApiState<dynamic> state) {
    if (state is ApiLoaded) {
      if (state.data is List<GenreModel>) {
        return state.data as List<GenreModel>;
      }
    }
    return [];
  }

  @override
  void dispose() {
    _trendingCubit.close();
    _popularCubit.close();
    _nowPlayingCubit.close();
    _topRatedCubit.close();
    _upcomingCubit.close();
    _genresCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _genresCubit.getMovieGenres();
          _trendingCubit.getTrendingMovies();
          _popularCubit.getPopularMovies(page: 1);
          _nowPlayingCubit.getNowPlayingMovies();
          _topRatedCubit.getTopRatedMovies();
          _upcomingCubit.getUpcomingMovies();
        },
        child: BlocBuilder<MainCubit, ApiState<dynamic>>(
          bloc: _genresCubit,
          builder: (context, genreState) {
            final genres = _getGenres(genreState);

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Popular Movies Section
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _popularCubit,
                    builder: (context, state) {
                      return MediaItem(
                        title: 'Popular',
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'movies_see_all',
                        seeAllExtra: {
                          'title': 'Popular Movies',
                          'category': 'popular',
                          'mediaType': 'main_cubit',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                      );
                    },
                  ),

                  _buildDivider(),

                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _nowPlayingCubit,
                    builder: (context, state) {
                      return NowPlayingSection(
                        title: "Playing In Theaters",
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'movies_see_all',
                        seeAllExtra: {
                          'title': 'Now Playing',
                          'category': 'now_playing',
                          'mediaType': 'main_cubit',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                        onRetry: () => _nowPlayingCubit.getNowPlayingMovies(),
                      );
                    },
                  ),

                  _buildDivider(),

                  // Trending Movies Section
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _trendingCubit,
                    builder: (context, state) {
                      return MediaItem(
                        title: 'Trending',
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'movies_see_all',
                        seeAllExtra: {
                          'title': 'Trending Movies',
                          'category': 'trending',
                          'mediaType': 'main_cubit',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                      );
                    },
                  ),

                  _buildDivider(),

                  // Top Rated Items
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _topRatedCubit,
                    builder: (context, state) {
                      return TopRatedSection(
                        title: 'Top Rated',
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'movies_see_all',
                        seeAllExtra: {
                          'title': 'Top Rated Movies',
                          'category': 'top_rated',
                          'mediaType': 'main_cubit',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                      );
                    },
                  ),

                  _buildDivider(),

                  // Upcoming Movies Section
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _upcomingCubit,
                    builder: (context, state) {
                      return MediaItem(
                        title: 'Upcoming',
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'movies_see_all',
                        seeAllExtra: {
                          'title': 'Upcoming Movies',
                          'category': 'upcoming',
                          'mediaType': 'main_cubit',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: const Divider(),
    );
  }
}