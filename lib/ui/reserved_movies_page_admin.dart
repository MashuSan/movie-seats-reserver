import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'movie_card_page_base.dart';

class ReservedMoviePageAdmin extends StatelessWidget {
  ReservedMoviePageAdmin({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser;

  static Widget create(BuildContext context) {
    return ReservedMoviePageAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return MovieCardPageBase(
      getDesired: getReserved, title: 'Planned Movies', isAdmin: true,);
  }

  Future<List<String>> getReserved(String collectionName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('movies')
        .where('reservedBy')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
