import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_theatre_app/models/movie_tv_detail.dart';
import 'package:movie_theatre_app/utils/movie_api_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_theatre_app/models/movie_model.dart';
import 'package:movie_theatre_app/utils/size_config.dart';

import '../models/movie_item.dart';
import '../models/tv_model.dart';
import '../utils/consts.dart';
import 'movie_card.dart';
import 'movie_detail_page.dart';

class MovieCardPageBase extends StatefulWidget {
  const MovieCardPageBase({
    Key? key,
    required this.getDesired,
    required this.title,
  }) : super(key: key);

  final Future<List<String>> Function(String) getDesired;
  final String title;

  @override
  State<MovieCardPageBase> createState() => _MovieCardPageBaseState();
}

class _MovieCardPageBaseState extends State<MovieCardPageBase> {
  final MoviesApiProvider _provider = MoviesApiProvider();
  late Future<List<dynamic>> _favoriteData;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _favoriteData = Future.wait([
      widget.getDesired(MovieItem.movie.name).then((ids) => _provider
          .fetchTrendingMovies()
          .then((movies) => filterMoviesByIds(movies, ids))),
      widget.getDesired(MovieItem.tv.name).then((ids) => _provider
          .fetchTrendingTv()
          .then((movies) => filterTvsByIds(movies, ids))),
    ]);
  }

  List<MovieModel> filterMoviesByIds(List<dynamic> movies, List<String> ids) {
    final filteredMovies = movies
        .where((movie) => ids.contains(movie['id'].toString()))
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
    return filteredMovies;
  }

  List<TvModel> filterTvsByIds(List<dynamic> movies, List<String> ids) {
    final filteredTvs = movies
        .where((tv) => ids.contains(tv['id'].toString()))
        .map((tv) => TvModel.fromJson(tv))
        .toList();
    return filteredTvs;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _favoriteData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<MovieTvDetail> favorites = List.from(snapshot.data![0])
              ..addAll(snapshot.data![1]);

            return CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  centerTitle: true,
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  expandedHeight: SizeConfig.screenHeight! * 0.10,
                  floating: true,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(widget.title),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final movie = favorites[index];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                movie: movie,
                                type: movie.type,
                              ),
                            ),
                          );

                          // After popping from MovieDetailPage, update the _favoriteData
                          setState(() {
                            _favoriteData = Future.wait([
                              widget.getDesired(MovieItem.movie.name).then((ids) =>
                                  _provider.fetchTrendingMovies().then(
                                          (movies) =>
                                          filterMoviesByIds(movies, ids))),
                              widget.getDesired(MovieItem.tv.name).then((ids) =>
                                  _provider.fetchTrendingTv().then(
                                          (movies) => filterTvsByIds(movies, ids)))
                            ]);
                          });
                        },
                        child: MovieCard(movie: movie),
                      );
                    },
                    childCount: favorites.length,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
