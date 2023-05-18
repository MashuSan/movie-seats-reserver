import 'movie_item.dart';
import 'movie_tv_detail.dart';

class MovieModel extends MovieTvDetail {
  final int vote_count;
  final String original_language;
  final String original_title;
  final List<dynamic> genre_ids;
  final String backdrop_path;
  final double popularity;
  final String media_type;

  MovieModel.fromJson(Map<String, dynamic> parsedJson)
      : vote_count = parsedJson['vote_count'],
  original_language = parsedJson['original_language'],
  original_title = parsedJson['original_title'],
  genre_ids = parsedJson['genre_ids'],
  backdrop_path = parsedJson['backdrop_path'],
  popularity = parsedJson['popularity'],
  media_type = parsedJson['media_type'],
  super(id: parsedJson['id'], type: MovieItem.movie, title: parsedJson['title'],
          overview: parsedJson['overview'], poster_path: parsedJson['poster_path'],
      vote_average: parsedJson['vote_average']);
}