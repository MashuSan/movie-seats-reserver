import 'dart:convert';
import 'package:http/http.dart' show get;
import 'package:http/http.dart' as http;

import '../models/cast_model.dart';
import 'consts.dart';

class MoviesApiProvider {
  Future<List<dynamic>> fetchTrendingMovies() async {
    final response = await get(Uri.parse(kTrendingMovies));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchTrendingTv() async {
    final response = await get(Uri.parse(kTrendingTv));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchTrending() async {
    final response = await get(Uri.parse(kTrending));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }
/*
  Future<DetailsModel> fetchDetails(int id, String tvOrMovie) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/$tvOrMovie/$id?api_key=$kApiKey&language=en-US'));
    final jsonBody = json.decode(response.body);
    return DetailsModel.fromJson(jsonBody);
  }
*/
  Future<CastModel> fetchCast(int id, String tvOrMovie) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/$tvOrMovie/$id/credits?api_key=$kApiKey'));
    final jsonBody = json.decode(response.body);
    return CastModel.fromJson(jsonBody);
  }

  Future<List<dynamic>> fetchReviews(int id) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/reviews?api_key=$kApiKey&language=en-US&page=1'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchSimilar(int id, String tvOrMovie) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/$tvOrMovie/$id/recommendations?api_key=$kApiKey&language=en-US&page=1'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchSearchResults(String query) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/multi?api_key=$kApiKey&language=en-US&query=$query&page=1&include_adult=false'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchTopRatedMovies(int page) async {
    final response = await get(Uri.parse('$kTopRated$page'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchPopularMovies(int page) async {
    final response = await get(Uri.parse('$kPopular$page'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchUpcomingMovies(int page) async {
    final response = await get(Uri.parse('$kUpcoming$page'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchPopularTv(int page) async {
    final response = await get(Uri.parse('$kTVPopular$page'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchArrivingTodayTv(int page) async {
    final response = await get(Uri.parse(
        'https://api.themoviedb.org/3/tv/airing_today?api_key=$kApiKey&language=en-US&page=$page'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }

  Future<List<dynamic>> fetchTopRatedTv(int page) async {
    final response = await get(Uri.parse(
        'https://api.themoviedb.org/3/tv/top_rated?api_key=$kApiKey&language=en-US&page=$page'));
    final jsonBody = json.decode(response.body);
    return jsonBody['results'];
  }
}