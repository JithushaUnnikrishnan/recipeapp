import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Add this package for easier rating bar implementation
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingPage extends StatefulWidget {
  final String recipeId;

  const RatingPage({super.key, required this.recipeId});

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0;
  var ID;

  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    setState(() {
      ID = spref.getString("Id");
    });
    print("sharedPreference Data get");
  }

  void _submitRating() async {
    final userId =ID; // Replace with actual user ID

    // Check if the user has already rated this recipe
    QuerySnapshot existingRating = await FirebaseFirestore.instance
        .collection('Ratings')
        .where('recipe_id', isEqualTo: widget.recipeId)
        .where('user_id', isEqualTo: userId)
        .get();

    if (existingRating.docs.isEmpty) {
      // Add new rating to Firestore
      await FirebaseFirestore.instance.collection('Ratings').add({
        'recipe_id': widget.recipeId,
        'user_id': userId,
        'rating': _rating,
      });
    } else {
      // Update existing rating
      await existingRating.docs.first.reference.update({'rating': _rating});
    }

    Navigator.pop(context); // Return to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Rate Recipe", style: GoogleFonts.russoOne(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Rate this Recipe",
              style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRating,
              child: Text("Submit", style: GoogleFonts.poppins(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}
