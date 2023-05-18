import 'movie_item.dart';
import 'movie_tv_detail.dart';

class TvModel extends MovieTvDetail {
  final String original_name;
  final vote_average;
  final String original_language;
  final String backdrop_path;
  final double popularity;
  final String first_air_date;
  final String media_type;

  TvModel.fromJson(Map<String, dynamic> parsedJson)
      : original_name = parsedJson['original_name'],
  vote_average = parsedJson['vote_average'],
  original_language = parsedJson['original_language'],
  backdrop_path = parsedJson['backdrop_path'],
  popularity = parsedJson['popularity'],
  first_air_date = parsedJson['first_air_date'],
  media_type = parsedJson['media_type'],
  super(
  id: parsedJson['id'],
  type: MovieItem.tv,
  title: parsedJson['name'],
  overview: parsedJson['overview'],
  poster_path: parsedJson['poster_path'],
        vote_average: parsedJson['vote_average']
  );
}
