class AppConstants {
  static String sessionId="session_id";
  static const String apiKey = 'f17ba8e7aeb5ceb6337fb9cd8c59fec1';

  // Movies
  static const String trendingMovies = '/trending/movie/week';
  static const String popularMovies = '/movie/popular';
  static String movieDetails(int id) => '/movie/$id';
  static String searchMovies = '/search/movie';
  static const String movieGenres = '/genre/movie/list';


  // TV Shows
  static const String trendingTv = '/trending/tv/week';
  static const String popularTv = '/tv/popular';
  static const String airingToday = '/tv/airing_today';
  static const String topRatedTv = '/tv/top_rated';
  static const String tvGenres = '/genre/tv/list';


}