import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/editmyreci.dart';
import 'package:recipe/view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRecii extends StatefulWidget {
  const MyRecii({super.key});

  @override
  State<MyRecii> createState() => _MyReciiState();
}

class _MyReciiState extends State<MyRecii> {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("Addrecipe")
          .where("user_id", isEqualTo: ID)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xFFEE364A),
          ));
        }
        if (snapshot.hasError) {
          return Text("Error${snapshot.error}");
        }
        final recipeview = snapshot.data?.docs ?? [];
        return Scaffold(
          appBar: AppBar(
            title: Text("My Recipes",
                style: GoogleFonts.poppins(color: Colors.white)),
            backgroundColor: Colors.black,
          ),
          body: ListView.builder(
            itemCount: recipeview.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewPage(id: recipeview[index].id)));
                    },
                    child: buildCard(context, recipeview[index]["reci_name"],
                        "delicious", recipeview[index]["image_url"], () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Editmyreci(id: recipeview[index].id)));
                    }, () {
                      setState(() {
                        FirebaseFirestore.instance
                            .collection("Addrecipe")
                            .doc(recipeview[index].id)
                            .delete();
                      });
                    }),
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Card buildCard(BuildContext context, String title, String description,
      String imagePath, onpressed, deleteonpressedd) {
    return Card(
      color: Color(0xFF5F5151), // Card color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imagePath,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.russoOne(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onpressed,
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: deleteonpressedd,
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
