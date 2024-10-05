import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appetizer extends StatefulWidget {
  final String searchQuery;
  const Appetizer({super.key, required this. searchQuery});

  @override
  State<Appetizer> createState() => _AppetizerState();
}

List<Color> color = [
  Colors.teal.shade200,
  Colors.yellow.shade200,
  Colors.red.shade200,
  Colors.green.shade100,
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

class _AppetizerState extends State<Appetizer> {
  var apptizer;

  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    setState(() {
      apptizer = spref.getString("Appetizers");
    });
    print("sharedPreference Data get");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("Addrecipe").where("category",isEqualTo: "appetizers").get(),
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
          final reciperappet = snapshot.data?.docs ?? [];
          final filteredRecipes = reciperappet.where((recipe) {
            final recipeName = recipe["reci_name"] as String;
            return recipeName.toLowerCase().contains(widget.searchQuery.toLowerCase());
          }).toList();
          return Scaffold(
            backgroundColor: Colors.black,
            body: filteredRecipes.isEmpty
          ? Center(
          child: Text(
            "No results found",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          )

                :ListView.builder(
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
                          filteredRecipes[index]["description"]),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * .01),

                  ],
                );
              },
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Text(
                description, // Use the appetizer name passed to the method
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
      height: 150,
      width: 395,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
    );
  }
}
