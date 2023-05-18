import 'package:flutter/material.dart';

enum MovieItem {movie , tv }

class MovieItemData{
  const  MovieItemData({required this.title,required this.icon});
  final String title;
  final IconData icon;

}