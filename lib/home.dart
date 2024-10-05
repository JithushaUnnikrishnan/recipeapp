import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe/view.dart';

class Homee extends StatefulWidget {
  final String searchQuery;
  const Homee({super.key, required this. searchQuery});

  @override
  State<Homee> createState() => _HomeeState();
}

List<Color> color = [
  Color(0XFFE9EAF4),
  Color(0XFFFFEEEA),
  Color(0XFFCDF2E0),
  Color(0XFFF4EEE1),
  Color(0XFFEBFAFE),
  Colors.cyan[200]!,
  Colors.amber,
  Colors.amber.shade200,
  Colors.white,
  Colors.lightGreen.shade300,
  Color(0XFFFFEEEA),
  Color(0XFFCDF2E0),
  Color(0XFFF4EEE1),
  Color(0XFFEBFAFE),
];

class _HomeeState extends State<Homee> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("Addrecipe").get(),
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
        final reciperdetail = snapshot.data?.docs ?? [];
        final filteredRecipes = reciperdetail.where((recipe) {
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
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .01,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewPage(id: filteredRecipes[index].id)));
                    },
                    child: buildContainer(
                        color[index],
                        NetworkImage(filteredRecipes[index]["image_url"]),
                        filteredRecipes[index]["reci_name"],
                        filteredRecipes[index]["description"]),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .01,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Container buildContainer(
      Color color, image, String text, String description) {
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
          SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.red, fontSize: 18),
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
