import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import '../../../repositories/movie_repository.dart';
import '../../../repositories/tv_repository.dart';
import 'state.dart';

class MainCubit extends Cubit<ApiState<dynamic>> {
  final MovieRepository _movieRepository;
  final TvRepository _tvRepository;

  MainCubit(this._movieRepository, this._tvRepository)
    : super(ApiInitial<dynamic>());

  // Generic fetch method
  Future<void> _fetchData<T>({
    required Future<ApiResponse<T>> Function() apiCall,
  }) async {
    emit(ApiLoading<T>());
    final response = await apiCall();

    response.when(
      success: (data) => emit(ApiLoaded<T>(data)),
      failure: (error) => emit(ApiError<T>(error)),
    );
  }

  //==================================================
  // ============ MOVIE METHODS ============
  Future<void> getTrendingMovies({int page=1}) =>
      _fetchData(apiCall: () => _movieRepository.getTrendingMovies(page));

  Future<void> getPopularMovies({int page = 1}) =>
      _fetchData(apiCall: () => _movieRepository.getPopularMovies(page));

  Future<void> getNowPlayingMovies({int page=1}) =>
      _fetchData(apiCall: () => _movieRepository.getNowPlayingMovies(page));

  Future<void> getUpcomingMovies({int page=1}) =>
      _fetchData(apiCall: () => _movieRepository.getUpcomingMovies(page));

  Future<void> getTopRatedMovies({int page=1}) =>
      _fetchData(apiCall: () => _movieRepository.getTopRatedMovies(page));

  Future<void> getMovieDetails(int id) =>
      _fetchData(apiCall: () => _movieRepository.getMovieDetails(id));

  Future<void> getMovieGenres() =>
      _fetchData(apiCall: () => _movieRepository.getMovieGenres());


  Future<void> searchMovies(String query) {
    if (query.isEmpty) {
      emit(ApiInitial<dynamic>());
      return Future.value();
    }
    return _fetchData(apiCall: () => _movieRepository.searchMovies(query));
  }

  //==================================================
  // ============ TV METHODS ============
  Future<void> getTrendingTvs({int page=1}) =>
      _fetchData(apiCall: () => _tvRepository.getTrendingTvs(page));

  Future<void> getPopularTvs({int page=1}) =>
      _fetchData(apiCall: () => _tvRepository.getPopularTvs(page));

  Future<void> getAiringToday({int page=1}) =>
      _fetchData(apiCall: () => _tvRepository.getAiringToday(page));

  Future<void> getNowPlayingTvs() =>
      _fetchData(apiCall: () => _tvRepository.getNowPlayingTvs());

  Future<void> getUpcomingTvs() =>
      _fetchData(apiCall: () => _tvRepository.getUpcomingTvs());

  Future<void> getTopRatedTvs({int page=1}) =>
      _fetchData(apiCall: () => _tvRepository.getTopRatedTvs(page));

  Future<void> getTvDetails(int id) =>
      _fetchData(apiCall: () => _tvRepository.getTvDetails(id));

  Future<void> getTvGenres() =>
    _fetchData(apiCall: () => _tvRepository.getTvGenres());

}
