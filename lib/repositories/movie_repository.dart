import '../../core/network/app_constants.dart';
import '../../core/network/api_client.dart';
import '../data/genres/genres.dart';
import '../data/models/movie_model.dart';

class MovieRepository {
  final ApiClient _apiClient;

  MovieRepository(this._apiClient);

  Future<ApiResponse<MovieModel>> getTrendingMovies(int page) async {
    return await _apiClient.getTyped<MovieModel>(
      endpoint: AppConstants.trendingMovies,
      queryParameters: {'page': page.toString()},
      fromJson: (data) => MovieModel.fromJson(data),
    );
  }

  Future<ApiResponse<MovieModel>> getPopularMovies(int page) async {
    return await _apiClient.getTyped<MovieModel>(
      endpoint: AppConstants.popularMovies,
      queryParameters: {'page': page.toString()},
      fromJson: (data) => MovieModel.fromJson(data),
    );
  }

  Future<ApiResponse<MovieModel>> getMovieDetails(int id) async {
    return await _apiClient.getTyped<MovieModel>(
      endpoint: AppConstants.movieDetails(id),
      fromJson: (data) => MovieModel.fromJson(data),
    );
  }

  Future<ApiResponse<List<MovieModel>>> searchMovies(String query) async {
    return await _apiClient.getTyped<List<MovieModel>>(
      endpoint: AppConstants.searchMovies,
      queryParameters: {'query': query},
      fromJson: (data) => (data['results'] as List)
          .map((json) => MovieModel.fromJson(json))
          .toList(),
    );
  }

  Future<ApiResponse<MovieModel>> getNowPlayingMovies(int page) async {
    return await _apiClient.getTyped<MovieModel>(
      endpoint: '/movie/now_playing',
      queryParameters: {'page': page.toString()},
      fromJson: (data) => MovieModel.fromJson(data),
    );
  }

  Future<ApiResponse<MovieModel>> getUpcomingMovies(int page) async {
    return await _apiClient.getTyped<MovieModel>(
      endpoint: '/movie/upcoming',
      queryParameters: {'page': page.toString()},
      fromJson: (data) => MovieModel.fromJson(data),
    );
  }

  Future<ApiResponse<MovieModel>> getTopRatedMovies(int page) async {
    return await _apiClient.getTyped<MovieModel>(
      endpoint: '/movie/top_rated',
      queryParameters: {'page': page.toString()},
      fromJson: (data) => MovieModel.fromJson(data),
    );
  }

  Future<ApiResponse<List<GenreModel>>> getMovieGenres() async {
    return await _apiClient.getTyped<List<GenreModel>>(
      endpoint: AppConstants.movieGenres,
      fromJson: (data) => (data['genres'] as List)
          .map((json) => GenreModel.fromJson(json))
          .toList(),
    );
  }
}
