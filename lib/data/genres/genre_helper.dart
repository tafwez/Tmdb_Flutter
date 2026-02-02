// data/main_cubit/genre_helper.dart

import 'genres.dart';

class GenreHelper {
  static String getGenreNames(List<int> genreIds, List<GenreModel>? genres) {
    if (genres == null || genres.isEmpty) return '';

    final genreNames = genreIds
        .map((id) {
          try {
            return genres.firstWhere((genre) => genre.id == id).name;
          } catch (e) {
            return null;
          }
        })
        .where((name) => name != null)
        .take(3) // Take only first 2 genres
        .join(', ');

    return genreNames;
  }

  static List<String> getGenreList(
    List<int> genreIds,
    List<GenreModel>? genres,
  ) {
    if (genres == null || genres.isEmpty) return [];

    return genreIds
        .map((id) {
          try {
            return genres.firstWhere((genre) => genre.id == id).name;
          } catch (e) {
            return null;
          }
        })
        .where((name) => name != null)
        .cast<String>()
        .take(3) // Take only first 2 genres
        .toList();
  }
}
