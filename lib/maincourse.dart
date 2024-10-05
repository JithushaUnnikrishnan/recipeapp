import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/view.dart';

class Maincourse extends StatefulWidget {
  final String searchQuery;
  const Maincourse({super.key, required this. searchQuery});

  @override
  State<Maincourse> createState() => _MaincourseState();
}

List<Color> color = [
  Colors.green.shade200,
  Colors.orange.shade200,
  Colors.red.shade200,
  Color(0XFFE9EAF4),
  Color(0XFFFFEEEA),
  Color(0XFFCDF2E0),
  Color(0XFFF4EEE1),
  Color(0XFFEBFAFE),
  Color(0XFFE9EAF4),
  Color(0XFFFFEEEA),
  Color(0XFFCDF2E0),
  Color(0XFFF4EEE1),
  Color(0XFFEBFAFE),
];

class _MaincourseState extends State<Maincourse> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("Addrecipe")
            .where("category", isEqualTo: "maincourse")
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Color(0xFFEE364A),
            ));
          }
          if (snapshot.hasError) {
            return Text("Error${snapshot.error}");
          }
          final recipermain = snapshot.data?.docs ?? [];
          final filteredRecipes = recipermain.where((recipe) {
            final recipeName = recipe["reci_name"] as String;
            final recipeDescription = recipe["description"] as String;
            return recipeName.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
                recipeDescription.toLowerCase().contains(widget.searchQuery.toLowerCase());
          }).toList();
          return Scaffold(
            backgroundColor: Colors.black,
            body: filteredRecipes.isEmpty
                ? Center(
              child: Text(
                "No results found",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ) :Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * .01),
                      InkWell(onTap: (){ Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewPage(id: filteredRecipes[index].id)));},
                        child: buildContainer(
                            color[index],
                            NetworkImage(filteredRecipes[index]["image_url"]),
                            filteredRecipes[index]["reci_name"],
                            filteredRecipes[index]["breif"]),
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height * .01),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }

  Container buildContainer(
      Color color, NetworkImage image, String name, String description) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              ClipOval(
                child: Image(
                  image: image,
                  fit: BoxFit.cover,
                  height: 120,
                  width: 120,
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
                Wrap(
                  children: [
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      height: 200,
      width: 395,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
    );
  }
}
