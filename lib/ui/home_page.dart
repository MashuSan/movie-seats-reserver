import 'package:flutter/material.dart';
import 'package:movie_theatre_app/ui/reserved_movies_page.dart';
import 'package:movie_theatre_app/utils/consts.dart';
import '../models/movie_item.dart';
import '../models/movie_model.dart';
import '../models/tv_model.dart';
import '../utils/movie_api_provider.dart';
import 'favorite_page.dart';
import 'message_page.dart';
import 'movie_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MoviesApiProvider moviesApiProvider = MoviesApiProvider();
  MovieItem _currentTab = MovieItem.movie;
  List<dynamic>? _trendingItems; // Make the _trendingItems list nullable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_currentTab.name),
        actions: _buildIcons(),
      ),
      body: FutureBuilder(
        future: _fetchTrendingItems(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            _trendingItems ??= snapshot.data; // Assign snapshot data if _trendingItems is null

            return ListView.builder(
              itemCount: _trendingItems!.length, // Use the non-null assertion operator (!) to access _trendingItems
              itemBuilder: (BuildContext context, int index) {
                final item = _trendingItems![index]; // Use the non-null assertion operator (!) to access _trendingItems
                final movie = _currentTab == MovieItem.movie
                    ? MovieModel.fromJson(item)
                    : TvModel.fromJson(item);

                return GestureDetector(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailPage(
                            movie: movie,
                            type: _currentTab,
                          ),
                        ),
                      );
                    },
                    leading: Image.network(
                      '$kImageUrl${movie.poster_path}',
                    ),
                    title: Text(movie.title),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchTrendingItems() {
    return _currentTab == MovieItem.movie
        ? moviesApiProvider.fetchTrendingMovies()
        : moviesApiProvider.fetchTrendingTv();
  }

  List<Widget> _buildIcons() {
    return [
      IconButton(
        icon: const Icon(Icons.movie),
        onPressed: () {
          setState(() {
            _currentTab = MovieItem.movie;
            _trendingItems = null; // Reset _trendingItems to null when switching tabs
          });
        },
      ),
      IconButton(
        icon: const Icon(Icons.live_tv),
        onPressed: () {
          setState(() {
            _currentTab = MovieItem.tv;
            _trendingItems = null; // Reset _trendingItems to null when switching tabs
          });
        },
      ),
      IconButton(
        icon: const Icon(Icons.favorite_rounded),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritePage()),
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.account_balance_wallet),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReservedMoviePage()),
          );
        },
      ),
      IconButton(
        icon: const Icon(Icons.message),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MessagePage())
          );
        },
      ),
    ];
  }

}