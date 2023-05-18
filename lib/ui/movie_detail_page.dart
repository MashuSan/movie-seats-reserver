import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_theatre_app/ui/seat_selection_page.dart';

import '../models/movie_item.dart';
import '../models/movie_tv_detail.dart';
import '../models/movie_model.dart';
import '../utils/consts.dart';
import '../utils/size_config.dart';

class MovieDetailPage extends StatefulWidget {
  final MovieTvDetail movie;
  final MovieItem type;

  const MovieDetailPage({Key? key, required this.movie, required this.type})
      : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection(getFavoriteCollection(widget.type.name))
        .doc(widget.movie.id.toString())
        .get();

    setState(() {
      isFavorite = snapshot.exists;
    });
  }

  void addToFavorites() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection(getFavoriteCollection(widget.type.name))
        .doc(widget.movie.id.toString())
        .set({
      'movieId': widget.movie.id,
    });

    setState(() {
      isFavorite = true;
    });
  }

  void buyTicket() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection("tickets")
        .doc(widget.movie.id.toString())
        .set({
      'movieId': widget.movie.id,
    });

    setState(() {
      isFavorite = true;
    });
  }

  void removeFromFavorites() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection(getFavoriteCollection(widget.type.name))
        .doc(widget.movie.id.toString())
        .delete();

    setState(() {
      isFavorite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildDetailPageForMovie(context, widget.movie);
  }

  Widget _buildDetailPageForMovie(BuildContext context, MovieTvDetail movie) {
    SizeConfig().init(context);

    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight! * 0.13,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel,
                        size: SizeConfig.screenHeight! * 0.04),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: isFavorite
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onPressed: () {
                      if (isFavorite) {
                        removeFromFavorites();
                      } else {
                        addToFavorites();
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.mediumPadding),
              height: SizeConfig.screenHeight! * 0.06,
              width: SizeConfig.screenHeight! * 0.30,
              child: Text(
                movie.title!,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: SizeConfig.screenHeight! * 0.025,
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.mediumPadding),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${movie.vote_average} / 10',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.screenHeight! * 0.017,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01),
            Container(
              margin:
                  EdgeInsets.symmetric(horizontal: SizeConfig.mediumPadding),
              height: SizeConfig.screenHeight! * 0.4,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('$kImageUrl${movie.poster_path}'),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.mediumPadding),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          movie.title!,
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                fontSize: SizeConfig.screenHeight! * 0.016,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.mediumPadding),
//child: FittedBox(
//fit: BoxFit.scaleDown,
//child: Text(parseDate(movie.release_date),style: Theme.of(context).textTheme.caption?.copyWith(fontSize: SizeConfig.screenHeight! * 0.016,fontWeight: FontWeight.w700),)),
                  ),
                ],
              ),
            ),
//Overview
            SizedBox(
              height: SizeConfig.screenHeight! * 0.20,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: SizeConfig.mediumPadding),
                child: Text(
                  movie.overview,
                  textAlign: TextAlign.start,
                  maxLines: 17,
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        fontSize: SizeConfig.screenHeight! * 0.018,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Colors.black.withOpacity(0.6),
                      ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.mediumPadding),
              child: SizedBox(
                width: double.infinity,
                height: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SeatSelectionPage(movieId: movie.id.toString())));
                  },
                  child: Text('Buy Ticket'),
                ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//06:

String parseDate(String date) {
  if (date == "") {
    return "";
  }
  DateTime dates = DateTime.parse(date);
  var formattedDate = '${dates.day}.${dates.month}.${dates.year}';
  return formattedDate;
}

void _showTicketBoughtMessage(context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('The ticket has been successfully bought'),
      duration: Duration(seconds: 2),
    ),
  );
}
