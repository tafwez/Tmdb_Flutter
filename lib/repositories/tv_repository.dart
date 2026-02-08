import 'package:tmdb_app/data/models/tv_detail_model.dart';
import 'package:tmdb_app/data/models/tv_model.dart';
import '../../core/network/app_constants.dart';
import '../../core/network/api_client.dart';
import '../data/genres/genres.dart';
import '../data/models/tv_cast_crew_model.dart';

class TvRepository {
  final ApiClient _apiClient;

  TvRepository(this._apiClient);

  Future<ApiResponse<TvModel>> getTrendingTvs(int page) async {
    return await _apiClient.getTyped<TvModel>(
      endpoint: AppConstants.trendingTv,
      queryParameters: {'page': page.toString()},
      fromJson: (data) => TvModel.fromJson(data),
    );
  }

  Future<ApiResponse<TvModel>> getPopularTvs(int page) async {
    return await _apiClient.getTyped<TvModel>(
        endpoint: AppConstants.popularTv,
        queryParameters: {'page':page.toString()},
        fromJson: (data) => TvModel.fromJson(data)
    );
  }

  Future<ApiResponse<TvModel>> getAiringToday(int page) async {
    return await _apiClient.getTyped<TvModel>(
        endpoint: AppConstants.airingToday,
        queryParameters: {'page': page.toString()},
        fromJson: (data) => TvModel.fromJson(data)
    );
  }

  /*Future<ApiResponse<TvModel>> getTvDetails(int id) async {
    return await _apiClient.getTyped<TvModel>(
      endpoint: AppConstants.movieDetails(id),
      fromJson: (data) => TvModel.fromJson(data),
    );
  }*/

  Future<ApiResponse<List<TvModel>>> searchTv(String query) async {
    return await _apiClient.getTyped<List<TvModel>>(
      endpoint: AppConstants.searchMovies,
      queryParameters: {'query': query},
      fromJson: (data) => (data['results'] as List)
          .map((json) => TvModel.fromJson(json))
          .toList(),
    );
  }

  Future<ApiResponse<TvModel>> getNowPlayingTvs() async {
    return await _apiClient.getTyped<TvModel>(
        endpoint: '/tv/now_playing',
        fromJson: (data) => TvModel.fromJson(data)
    );
  }

  Future<ApiResponse<TvModel>> getUpcomingTvs() async {
    return await _apiClient.getTyped<TvModel>(
        endpoint: '/tv/upcoming',
        fromJson: (data) => TvModel.fromJson(data)
    );
  }

  Future<ApiResponse<TvModel>> getTopRatedTvs(int page) async {
    return await _apiClient.getTyped<TvModel>(
        endpoint: AppConstants.topRatedTv,
        queryParameters: {'page':page.toString()},
        fromJson: (data)=> TvModel.fromJson(data)
    );
  }

  Future<ApiResponse<List<GenreModel>>> getTvGenres() async {
    return await _apiClient.getTyped<List<GenreModel>>(
      endpoint: AppConstants.tvGenres,
      fromJson: (data) => (data['genres'] as List)
          .map((json) => GenreModel.fromJson(json))
          .toList(),
    );
  }

  Future<ApiResponse<TvDetailModel>> getTvDetails(int id) async {
    return await _apiClient.getTyped<TvDetailModel>(
      endpoint: '/tv/$id',
      fromJson: (data) => TvDetailModel.fromJson(data),
    );
  }

  Future<ApiResponse<TvCastCrewModel>> getTVCastCrew(int tv_id) async {
    return await _apiClient.getTyped<TvCastCrewModel>(
      endpoint: '/tv/$tv_id/credits',
      fromJson: (data) => TvCastCrewModel.fromJson(data),
    );
  }
}