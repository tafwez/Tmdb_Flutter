import 'package:tmdb_app/core/network/api_client.dart';
import 'package:tmdb_app/core/network/app_constants.dart';
import 'package:tmdb_app/data/models/celebrities_model.dart';

class CelebritiesRepo {
  final ApiClient apiClient;

  CelebritiesRepo(this.apiClient);

  Future<ApiResponse<CelebritiesModel>> getCelebrities(int page) async {
    return await apiClient.getTyped<CelebritiesModel>(
      endpoint: AppConstants.popularCelebs,
      fromJson: (data) => CelebritiesModel.fromJson(data),
    );
  }
}
