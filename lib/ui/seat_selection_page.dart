import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieId;

  const SeatSelectionPage({required this.movieId});

  @override
  _SeatSelectionPageState createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  final user = FirebaseAuth.instance.currentUser;
  late List<String> selectedSeats = [];
  late Map<String, String> reservedBySeats = {};

  @override
  void initState() {
    super.initState();
    loadReservedSeats();
  }

  void loadReservedSeats() {
    final movieId = widget.movieId;
    FirebaseFirestore.instance.collection('movies').doc(movieId).get().then((doc) {
      if (doc.exists) {
        setState(() {
          reservedBySeats = Map.from(doc.data()!['reservedBy'] ?? {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Selection'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select your seats:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) {
                  String seatId = 'seat_${index + 1}';
                  bool isSelected = selectedSeats.contains(seatId);
                  String reservedByUserId = reservedBySeats[seatId] ?? '';

                  Color seatColor = Colors.grey;
                  if (isSelected) {
                    seatColor = Colors.green;
                  } else if (reservedByUserId == user?.uid) {
                    seatColor = Colors.yellow;
                  } else if (reservedByUserId.isNotEmpty) {
                    seatColor = Colors.red;
                  }

                  return GestureDetector(
                    onTap: () {
                      if (reservedByUserId == '' || reservedByUserId == user?.uid) {
                        setState(() {
                          if (isSelected) {
                            selectedSeats.remove(seatId);
                          } else {
                            selectedSeats.add(seatId);
                          }
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: seatColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Text(
                          seatId,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                reserveTicket();
              },
              child: Text('Reserve Ticket'),
            ),
          ],
        ),
      ),
    );
  }

  void reserveTicket() {
    final userId = user?.uid; // Get the user ID
    final movieId = widget.movieId; // Get the movie ID

    // Update the reservedBySeats map with the selected seats
    selectedSeats.forEach((seatId) {
      if (reservedBySeats[seatId] == null || reservedBySeats[seatId] == userId) {
        reservedBySeats[seatId] = userId ?? '';
      }
    });

    FirebaseFirestore.instance.collection('movies').doc(movieId).get().then((doc) {
      if (doc.exists) {
        Map<String, dynamic> movieData = doc.data()!;
        Map<String, String> reservedByData = Map.from(movieData['reservedBy'] ?? {});
        selectedSeats.forEach((seatId) {
          if (reservedByData[seatId] == null || reservedByData[seatId] == userId) {
            reservedByData[seatId] = userId ?? '';
          }
        });
        movieData['reservedBy'] = reservedByData;

        FirebaseFirestore.instance.collection('movies').doc(movieId).set(movieData).then((_) {
          // Show a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ticket reserved successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          // Clear the selected seats
          setState(() {
            selectedSeats.clear();
          });
        }).catchError((error) {
          // Show an error message if the creation fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reserve ticket'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      } else {
        // Create a new entry for the movie
        Map<String, dynamic> movieData = {
          'reservedBy': {for (var seatId in selectedSeats) seatId: userId}
        };

        FirebaseFirestore.instance.collection('movies').doc(movieId).set(movieData).then((_) {
          // Show a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ticket reserved successfully'),
              duration: Duration(seconds: 2),
            ),
          );

          // Clear the selected seats
          setState(() {
            selectedSeats.clear();
          });
        }).catchError((error) {
          // Show an error message if the creation fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reserve ticket'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    }).catchError((error) {
      // Show an error message if the database retrieval fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to retrieve movie details'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}