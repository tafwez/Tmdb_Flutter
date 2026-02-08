import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_app/data/genres/genres.dart';

import '../../../data/genres/genre_helper.dart';
import 'movie_Item.dart';

class TopRatedSection extends StatelessWidget {
  final String title;
  final List<MediaItemModel> items;
  final List<GenreModel> genres;
  final String seeAllRoute;
  final String itemDetailRoute;
  final Map<String, dynamic> seeAllExtra;
  final bool isLoading;
  final String? errorMessage;

  const TopRatedSection({
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
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigate to see all screen
                      context.pushNamed(seeAllRoute, extra: seeAllExtra);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
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
        SizedBox(
          height: 300,
          child: _buildContent(context),
        ),
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
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
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

    // Success state - Split items into chunks of 4
    final chunks = <List<MediaItemModel>>[];
    for (int i = 0; i < items.length; i += 4) {
      chunks.add(
        items.sublist(
          i,
          i + 4 > items.length ? items.length : i + 4,
        ),
      );
    }

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: chunks.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, columnIndex) {
        final columnItems = chunks[columnIndex];

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: columnItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: _MediaCard(
                  item: item,
                  onTap: () {
                    context.pushNamed(
                      itemDetailRoute,
                      extra: {"id": item.id.toString(), "title": item.title.toString()},
                    );
                  },
                  genres: genres,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _MediaCard extends StatelessWidget {
  final MediaItemModel item;
  final VoidCallback onTap;
  final List<GenreModel> genres;

  const _MediaCard({
    required this.item,
    required this.onTap,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    final genreNames = GenreHelper.getGenreList(item.genreIds, genres);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        child: Row(
          children: [
            // Backdrop/Poster
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Hero(
                tag: 'media_${item.id}',
                child: item.backdropPath != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${item.backdropPath}',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  ),
                )
                    : _buildPlaceholder(),
              ),
            ),

            const SizedBox(width: 10),

            // Content Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (genreNames.isNotEmpty) const SizedBox(height: 6),
                  if (genreNames.isNotEmpty)
                    Text(
                      genreNames.join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.movie, size: 30),
    );
  }
}