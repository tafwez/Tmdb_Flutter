import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tmdb_app/data/models/movie_model.dart';
import '../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../core/cubits/main_cubit/state.dart';
import '../../../core/helper/service_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/genres/genre_helper.dart';
import '../../../data/genres/genres.dart';

class SeeAll extends StatefulWidget {
  final String? title;
  final String? category;
  final String? mediaType;

  const SeeAll({super.key, this.title, this.category, this.mediaType});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  // Cubits
  late final MainCubit _moviesCubit;
  late final MainCubit _genresCubit;

  // Pagination Controller - manages the paged list
  final PagingController<int, Result> _pagingController = PagingController(
    firstPageKey: 1, // Start from page 1
  );

  // Store genres locally
  List<GenreModel> _genres = [];

  @override
  void initState() {
    super.initState();

    // Initialize cubits
    _moviesCubit = getIt<MainCubit>();
    _genresCubit = getIt<MainCubit>()..getMovieGenres();

    // Listen to page requests (when user scrolls to bottom)
    _pagingController.addPageRequestListener((pageNumber) {
      _fetchMoviesForPage(pageNumber);
    });

    // Listen to genre changes
    _genresCubit.stream.listen((state) {
      if (state is ApiLoaded && state.data is List<GenreModel>) {
        setState(() {
          _genres = state.data as List<GenreModel>;
        });
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _moviesCubit.close();
    _genresCubit.close();
    super.dispose();
  }

  // Fetch movies for a specific page
  void _fetchMoviesForPage(int pageNumber) {
    if (widget.category == 'popular') {
      _moviesCubit.getPopularMovies(pageNumber);
    } else if (widget.category == 'trending') {
      _moviesCubit.getTrendingMovies(pageNumber);
    } else if (widget.category == 'now_playing') {
      _moviesCubit.getNowPlayingMovies(pageNumber);
    } else if (widget.category == 'top_rated') {
      _moviesCubit.getTopRatedMovies(pageNumber);
    } else if (widget.category == 'upcoming') {
      _moviesCubit.getUpcomingMovies(pageNumber);
    } else {
      _moviesCubit.getPopularMovies(pageNumber);
    }

    // Listen to the response
    _moviesCubit.stream.first.then((state) {
      if (state is ApiLoaded<MovieModel>) {
        final movieData = state.data;
        final newMovies = movieData.results;
        final totalPages = movieData.totalPages ?? 1;

        // Check if this is the last page
        final isLastPage = pageNumber >= totalPages;

        if (isLastPage) {
          // No more pages, append last page
          _pagingController.appendLastPage(newMovies);
        } else {
          // There are more pages, append this page and set next page number
          final nextPageNumber = pageNumber + 1;
          _pagingController.appendPage(newMovies, nextPageNumber);
        }
      } else if (state is ApiError) {
        // Show error
        _pagingController.error = state.message;
      }
    });
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
        title: Text(widget.title ?? ''),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh both genres and movies
          _genresCubit.getMovieGenres();
          _pagingController.refresh(); // This will trigger page 1 again
        },
        child: PagedListView<int, Result>(
          pagingController: _pagingController,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          builderDelegate: PagedChildBuilderDelegate<Result>(
            // Build each movie item
            itemBuilder: (context, movie, index) {
              return _MovieCard(
                movie: movie,
                genres: _genres,
                onTap: () {
                  // TODO: Navigate to movie details
                },
              );
            },

            // Show loading indicator for first page
            firstPageProgressIndicatorBuilder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },

            // Show loading indicator when loading more pages
            newPageProgressIndicatorBuilder: (context) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },

            // Show error for first page
            firstPageErrorIndicatorBuilder: (context) {
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
                        _pagingController.error?.toString() ?? 'An error occurred',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _pagingController.refresh();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },

            // Show error when loading more pages fails
            newPageErrorIndicatorBuilder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Error loading more movies',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        _pagingController.retryLastFailedRequest();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            },

            // Show when no items found
            noItemsFoundIndicatorBuilder: (context) {
              return const Center(
                child: Text('No movies found'),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Result movie;
  final VoidCallback onTap;
  final List<GenreModel> genres;

  const _MovieCard({
    required this.movie,
    required this.onTap,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    final genreNames = GenreHelper.getGenreList(movie.genreIds, genres);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Row(
          children: [
            // Movie Poster
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Hero(
                tag: 'movie_${movie.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1),
                  child: Image.network(
                    movie.fullPosterPath,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 60,
                        width: 60,
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
                      return Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.movie, size: 30),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Movie Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title ?? 'No title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (genreNames.isNotEmpty) const SizedBox(height: 6),
                  if (genreNames.isNotEmpty)
                    Text(
                      genreNames.join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  const SizedBox(height: 6),

                  // Rating
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: movie.voteAverage! / 2,
                        itemBuilder: (context, index) =>
                        const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 14.0,
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        movie.voteAverage!.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
          ],
        ),
      ),
    );
  }
}