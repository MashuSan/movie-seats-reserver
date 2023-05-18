import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'movie_card_page_base.dart';

class ReservedMoviePage extends StatelessWidget {
  ReservedMoviePage({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser;

  static Widget create(BuildContext context) {
    return ReservedMoviePage();
  }

  @override
  Widget build(BuildContext context) {
    return MovieCardPageBase(
      getDesired: getReserved, title: 'Reserved Tickets',);
  }

  Future<List<String>> getReserved(String collectionName) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('movies')
        .where('reservedBy')
        .get();

    final List<String> reservedMovies = [];
    for (final doc in snapshot.docs) {
      final reservedBy = doc.data()['reservedBy'] as Map<dynamic, dynamic>;
      if (reservedBy.containsValue(userId)) {
        reservedMovies.add(doc.id);
      }
    }

    return reservedMovies;
  }
}
