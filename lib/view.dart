import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({
    super.key,
    required this.id,
  });
  final String id;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  bool isFavorited = false;
  void initState() {
    super.initState();
    _checkIfFavorited();
  }
  Future<void> _checkIfFavorited() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('Favorites').doc(widget.id).get();
    if (snapshot.exists) {
      setState(() {
        isFavorited = true;
      });
    } else {
      setState(() {
        isFavorited = false;
      });
    }
  }


  @override

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection("Addrecipe").doc(widget.id).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("Recipe not found."));
        }


        final recipevieww = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      recipevieww["image_url"],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),


                  Text(
                    recipevieww["reci_name"],
                    style: GoogleFonts.russoOne(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.white,
                    ),
                    onPressed: () async {
                      setState(() {
                        isFavorited = !isFavorited;
                      });

                      if (isFavorited) {

                        await FirebaseFirestore.instance.collection("Favorites").doc(widget.id).set({
                          'id': widget.id,
                          'reci_name': recipevieww['reci_name'],
                          'image_url': recipevieww['image_url'],
                          'time': recipevieww['time'],
                          'servings': recipevieww['servings'],
                          'ingredients': recipevieww['ingredients'],
                          'description': recipevieww['description'],
                        });
                      } else {

                        await FirebaseFirestore.instance.collection("Favorites").doc(widget.id).delete();
                      }
                    },
                  ),

                  SizedBox(height: 10),


                  Wrap(
                    children: [
                      Text(
                        "Cooking Time: ",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        recipevieww["time"],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(width: 100),
                      Row(
                        children: [
                          Text(
                            "Serves: ",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                          Text(
                            recipevieww["servings"],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(height: 10),
                  //
                  // Row(
                  //   children: [
                  //     Icon(Icons.star, color: Colors.yellow[700], size: 24),
                  //     Icon(Icons.star, color: Colors.yellow[700], size: 24),
                  //     Icon(Icons.star, color: Colors.yellow[700], size: 24),
                  //     Icon(Icons.star, color: Colors.yellow[700], size: 24),
                  //     Icon(Icons.star_half, color: Colors.yellow[700], size: 24),
                  //     SizedBox(width: 8),
                  //     Text(
                  //       "4.5 / 5.0",
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 16,
                  //         color: Colors.grey[400],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 20),

                  Text(
                    "Ingredients:",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Ingredients List
                  Text(
                    recipevieww["ingredients"],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    "Description:",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    recipevieww["description"],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
