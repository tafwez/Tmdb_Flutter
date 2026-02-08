import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb_app/data/models/tv_model.dart';
import '../../core/cubits/main_cubit/main_cubit.dart';
import '../../core/cubits/main_cubit/state.dart';
import '../../core/helper/service_locator.dart';
import '../../data/genres/genres.dart';
import '../widgets/movie_Item.dart';
import '../widgets/now_playing_item.dart';
import '../widgets/toprated_items.dart';

class TvshowsScreen extends StatefulWidget {
  const TvshowsScreen({super.key});

  @override
  State<TvshowsScreen> createState() => _TvshowsScreenState();
}

class _TvshowsScreenState extends State<TvshowsScreen> {
  late final MainCubit _trendingTvShows;
  late final MainCubit _airingToday;
  late final MainCubit _topRatedTvShows;
  late final MainCubit _popularTvShows;
  late final MainCubit _genresCubit;

  final int firstPage=1;

  @override
  void initState() {
    super.initState();
    _genresCubit = getIt<MainCubit>()..getTvGenres();
    _trendingTvShows = getIt<MainCubit>()..getTrendingTvs(firstPage);
    _airingToday = getIt<MainCubit>()..getAiringToday(firstPage);
    _topRatedTvShows = getIt<MainCubit>()..getTopRatedTvs(firstPage);
    _popularTvShows = getIt<MainCubit>()..getPopularTvs(firstPage);
  }

  List<MediaItemModel> _getMediaItems(ApiState<dynamic> state) {
    if (state is ApiLoaded<TvModel>) {
      return state.data.results
          .map((m) => MediaItemModel.fromTvResult(m))
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
    _trendingTvShows.close();
    _airingToday.close();
    _topRatedTvShows.close();
    _popularTvShows.close();
    _genresCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _genresCubit.getTvGenres();
          _trendingTvShows.getTrendingTvs(firstPage);
          _airingToday.getAiringToday(firstPage);
          _topRatedTvShows.getTopRatedTvs(firstPage);
          _popularTvShows.getPopularTvs(firstPage);
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
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _airingToday,
                    builder: (context, state) {
                      return NowPlayingSection(
                        title: "Airing Today",
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'tv_see_all',
                        itemDetailRoute: 'tv_details',
                        seeAllExtra: {
                          'title': 'Airing Today',
                          'category': 'airing_today',
                          'mediaType': 'tv',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                        onRetry: () => _airingToday.getAiringToday(firstPage),
                      );
                    },
                  ),

                  _buildDivider(),

                  // Trending TV Shows Section
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _trendingTvShows,
                    builder: (context, state) {
                      return MediaItem(
                        title: 'Trending',
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'tv_see_all',
                        itemDetailRoute:'tv_details',
                        seeAllExtra: {
                          'title': 'Trending TV',
                          'category': 'trending',
                          'mediaType': 'tv',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                      );
                    },
                  ),

                  _buildDivider(),

                  // Top Rated TV Shows
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _topRatedTvShows,
                    builder: (context, state) {
                      return TopRatedSection(
                        title: 'Top Rated',
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'tv_see_all',
                        itemDetailRoute: 'tv_details',
                        seeAllExtra: {
                          'title': 'Top Rated TV ',
                          'category': 'top_rated',
                          'mediaType': 'tv',
                        },
                        isLoading: state is ApiLoading,
                        errorMessage: state is ApiError ? state.message : null,
                      );
                    },
                  ),

                  _buildDivider(),

                  // Popular TV Shows
                  BlocBuilder<MainCubit, ApiState<dynamic>>(
                    bloc: _popularTvShows,
                    builder: (context, state) {
                      return MediaItem(
                        title: "Popular",
                        items: _getMediaItems(state),
                        genres: genres,
                        seeAllRoute: 'tv_see_all',
                        itemDetailRoute:'tv_details',
                        seeAllExtra: {
                          'title': 'Popular TV ',
                          'category': 'popular',
                          'mediaType': 'tv',
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