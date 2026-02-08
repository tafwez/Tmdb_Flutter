import 'package:get_it/get_it.dart';
import 'package:tmdb_app/core/network/app_constants.dart';
import 'package:tmdb_app/repositories/movie_repository.dart';
import 'package:tmdb_app/repositories/tv_repository.dart';
import '../../repositories/celebrities_repository.dart';
import '../cubits/auth/auth_cubit.dart';
import '../cubits/main_cubit/main_cubit.dart';
import '../network/api_client.dart';
import '../theme/theme_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Theme cubit
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  // Register API Client as singleton
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(apiKey: AppConstants.apiKey),
  );

  // Register Auth Cubit as singleton
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt<ApiClient>()));

  // Register Movie Repository as singleton
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepository(getIt<ApiClient>()),
  );

  // Register TV Repository as singleton
  getIt.registerLazySingleton<TvRepository>(
    () => TvRepository(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<CelebritiesRepo>(
      ()=> CelebritiesRepo(getIt<ApiClient>()),
  );

  getIt.registerFactory<MainCubit>(
    () => MainCubit(getIt<MovieRepository>(), getIt<TvRepository>(),getIt<CelebritiesRepo>()),
  );
}
