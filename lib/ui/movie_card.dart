import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/movie_item.dart';
import '../models/movie_model.dart';
import '../models/movie_tv_detail.dart';
import '../utils/consts.dart';
import '../utils/size_config.dart';
import 'movie_detail_page.dart';

class MovieCard extends StatelessWidget {
  final MovieTvDetail movie;

  const  MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      height: SizeConfig.screenHeight! * 0.12,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.smallPadding),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.smallPadding, vertical:
                  SizeConfig.screenHeight! * 0.005),

                  width: SizeConfig.screenWidth! * 0.19,
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage('$kImageUrl${movie.poster_path}'),
                        fit: BoxFit.fitWidth
                    ),
                  ),
                ),

                //Title Box
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.screenHeight! * 0.005),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text(_parseListOfGenresIntoString(movie.genres), style: Theme
                      //.of(context)
                      //.textTheme
                      //.caption,),
                      SizedBox(
                          height: SizeConfig.screenHeight! * 0.05,
                          width: SizeConfig.screenWidth! * 0.45,
                          child: Text(movie.title!, style: Theme
                              .of(context)
                              .
                          textTheme
                              .bodyText1
                              ?.copyWith(fontSize: SizeConfig.screenHeight! *
                              0.018,
                              fontWeight: FontWeight.w700))),
                      SizedBox(height: SizeConfig.screenHeight! * 0.002),
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.screenWidth! * 0.02),
                        height: 0.5,
                        color: inactiveColor,
                        width: SizeConfig.screenWidth! * 0.65,)
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                Icon(Icons.arrow_forward_ios, color: inactiveColor),
                const Spacer(flex: 1),
              ]),
        ),
      );
  }
}
/*
  String _parseListOfGenresIntoString(genres) {
    String result = genres.toString().replaceAll('[','')
        .replaceAll(']', '').replaceAll(',', ' |');
    return result;
  }*/