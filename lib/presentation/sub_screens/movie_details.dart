import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tmdb_app/core/cubits/main_cubit/main_cubit.dart';
import 'package:tmdb_app/core/cubits/main_cubit/state.dart';
import 'package:tmdb_app/core/helper/service_locator.dart';
import 'package:tmdb_app/data/models/movie_detail_model.dart';
import 'package:tmdb_app/data/models/cast_crew_model.dart';
import 'package:tmdb_app/presentation/widgets/poster_image.dart';
import 'package:tmdb_app/presentation/widgets/rating_bar.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/cast_crew_ui.dart';

class MovieDetails extends StatefulWidget {
  final String id;
  final String title;

  const MovieDetails({super.key, required this.id, required this.title});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late final MainCubit _detailsCubit;
  late final MainCubit _creditsCubit;

  MovieDetailModel? movieDetails;
  CastCrewModel? credits;

  @override
  void initState() {
    super.initState();
    _detailsCubit = getIt<MainCubit>()..getMovieDetails(int.parse(widget.id));
    _creditsCubit = getIt<MainCubit>()..getMovieCredits(int.parse(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark
              ? AppColors.darkIconPrimary
              : AppColors.lightIconPrimary,
        ),
        title: Text(widget.title.toString()),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _detailsCubit.getMovieDetails(int.parse(widget.id));
          _creditsCubit.getMovieCredits(int.parse(widget.id));
        },
        child: BlocBuilder<MainCubit, ApiState<dynamic>>(
          bloc: _detailsCubit,
          builder: (context, detailsState) {
            return BlocBuilder<MainCubit, ApiState<dynamic>>(
              bloc: _creditsCubit,
              builder: (context, creditsState) {
                // Show loading if either is loading
                if (detailsState is ApiLoading || creditsState is ApiLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Show error if details failed (primary data)
                if (detailsState is ApiError) {
                  return Center(child: Text('Error: ${detailsState.message}'));
                }

                // Extract data when loaded
                if (detailsState is ApiLoaded) {
                  movieDetails = detailsState.data as MovieDetailModel;
                }

                if (creditsState is ApiLoaded) {
                  credits = creditsState.data as CastCrewModel;
                }

                // Show content when details are loaded (credits can still be loading)
                if (movieDetails != null) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Movie Details Section
                        MoviesDetailPage(
                          key: ValueKey(movieDetails!.id),
                          item: movieDetails!,
                        ),

                        // Cast & Crew Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Cast',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            SizedBox(height: 10),
                            if (credits != null)
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: credits!.cast.length > 10
                                      ? 10
                                      : credits!.cast.length,
                                  itemBuilder: (context, index) {
                                    final cast = credits!.cast[index];
                                    return CastCrewUi(cast: cast);
                                  },
                                ),
                              )
                            else if (creditsState is ApiError)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Failed to load cast'),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Center(child: CircularProgressIndicator()),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}

class MoviesDetailPage extends StatelessWidget {
  final MovieDetailModel item;

  const MoviesDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Backdrop image
        PosterImage(
          posterPath: item.backdropPath,
          width: MediaQuery.of(context).size.width,
          height: 200,
          heroTag: 'media_${item.id}_backdrop',
          showBorder: false,
        ),

        // Overlapping content with negative margin
        Transform.translate(
          offset: Offset(0, -14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // poster
                PosterImage(
                  posterPath: item.posterPath,
                  width: 100,
                  height: 140,
                  heroTag: 'media_${item.id}',
                  showBorder: false,
                  borderRadius: 0,
                ),
                // text group
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          item.title.toString(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 5),
                        TmdbRatingRow(
                          voteAverage: item.voteAverage!,
                          voteCount: item.voteCount!,
                        ),
                        SizedBox(height: 8),
                        // chip list
                        SizedBox(
                          height: 34,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: item.genres.length,
                            itemBuilder: (context, index) {
                              final genre = item.genres[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        genre.name ?? "no genre available",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          item.overview ?? 'no overview',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

