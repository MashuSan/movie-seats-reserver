import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/consts.dart';
import 'movie_card_page_base.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser;

  static Widget create(BuildContext context) {
    return FavoritePage();
  }

  @override
  Widget build(BuildContext context) {
    return MovieCardPageBase(getDesired: getFavorites, title: 'Favorites', isAdmin: false,);
  }

  Future<List<String>> getFavorites(String collectionName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection(getFavoriteCollection(collectionName))
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
