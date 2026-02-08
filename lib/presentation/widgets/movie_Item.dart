import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_app/data/models/movie_model.dart' as movie_model;
import 'package:tmdb_app/data/models/tv_model.dart' as tv_model;
import 'package:tmdb_app/data/genres/genres.dart';
import '../../../data/genres/genre_helper.dart';

class MediaItem extends StatelessWidget {
  final String title;
  final List<MediaItemModel> items; // ✅ Pass data directly
  final List<GenreModel> genres;
  final String seeAllRoute;
  final String itemDetailRoute;
  final Map<String, dynamic> seeAllExtra;
  final bool isLoading;
  final String? errorMessage;

  const MediaItem({
    required this.title,
    required this.items,
    required this.genres,
    required this.seeAllRoute,
    required this.itemDetailRoute,
    required this.seeAllExtra,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      context.pushNamed(seeAllRoute, extra: seeAllExtra);
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'See All',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Icon(Icons.navigate_next),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Content
        SizedBox(height: 250, child: _buildContent(context)),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    // Loading state
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error state
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (items.isEmpty) {
      return const Center(child: Text('No content found'));
    }

    // Success state
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _MediaCard(
          item: item,
          genres: genres,
          onTap: () {
            context.pushNamed(
              itemDetailRoute,
              extra: {"id": item.id.toString(), "title": item.title.toString()},
            );
          },
        );
      },
    );
  }
}

class _MediaCard extends StatelessWidget {
  final MediaItemModel item;
  final List<GenreModel>? genres;
  final VoidCallback onTap;

  const _MediaCard({required this.item, this.genres, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final genreNames = GenreHelper.getGenreList(item.genreIds, genres);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Hero(
              tag: 'media_${item.id}',
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: item.posterPath != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500${item.posterPath}',
                        height: 160,
                        width: 130,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 160,
                            width: 130,
                            decoration: BoxDecoration(color: Colors.grey[300]),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(context);
                        },
                      )
                    : _buildPlaceholder(context),
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),

            // Genres
            if (genreNames.isNotEmpty)
              Text(
                genreNames.join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
              ),
            const SizedBox(height: 6),

            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  item.voteAverage.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: 160,
      width: 130,
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: const Icon(Icons.movie, size: 48),
    );
  }
}

class MediaItemModel {
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final double voteAverage;
  final List<int> genreIds;

  MediaItemModel({
    required this.id,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    required this.voteAverage,
    this.genreIds = const [],
  });

  // ✅ Factory to convert from Movie Result
  factory MediaItemModel.fromMovieResult(movie_model.Result movie) {
    return MediaItemModel(
      id: movie.id ?? 0,
      title: movie.title ?? 'No Title',
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      overview: movie.overview,
      voteAverage: movie.voteAverage ?? 0.0,
      genreIds: movie.genreIds,
    );
  }

  // ✅ Factory to convert from TV Result
  factory MediaItemModel.fromTvResult(tv_model.Result tvShow) {
    return MediaItemModel(
      id: tvShow.id ?? 0,
      title: tvShow.name ?? 'No Title',
      // TV uses 'name' instead of 'title'
      posterPath: tvShow.posterPath,
      backdropPath: tvShow.backdropPath,
      overview: tvShow.overview,
      voteAverage: tvShow.voteAverage ?? 0.0,
      genreIds: tvShow.genreIds,
    );
  }
}
