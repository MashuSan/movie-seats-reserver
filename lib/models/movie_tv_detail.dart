import 'movie_item.dart';

class MovieTvDetail {
  final int id;
  final MovieItem type;
  final String title;
  final String overview;
  final String poster_path;
  final vote_average;

  MovieTvDetail({
    required this.id,
    required this.type,
    required this.title,
    required this.overview,
    required this.poster_path,
    required this.vote_average,
  });
}