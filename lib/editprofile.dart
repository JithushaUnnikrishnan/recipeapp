import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipe/bottomnavigation.dart';
import 'package:recipe/profile.dart';

import 'models/navigationmodel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.id});
  final id;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final formkey = GlobalKey<FormState>();
  var name = TextEditingController();
  var phone = TextEditingController();
  var about = TextEditingController();
  Future<dynamic> Editprofile() async {
    await FirebaseFirestore.instance
        .collection("RecipeSign")
        .doc(widget.id)
        .update({
      "name":name.text,
      "Phone":phone.text
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Bottomnavigation()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Edit Profile",
              style: GoogleFonts.russoOne(color: Colors.white)),
          backgroundColor: Color(0xFF5F5151),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Empty";
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Empty";
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  labelText: "Phone",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[850],
                ),
              ),
//               SizedBox(height: 20),
//               TextFormField(
//                 validator: (value){if(value!.isEmpty){return "Empty";}},
// controller: about,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide.none,
//                   ),
//                   labelText: "About",
//                   labelStyle: TextStyle(color: Colors.white),
//                   filled: true,
//                   fillColor: Colors.grey[850],
//                 ),
//               ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    Provider.of<NavigationModel>(context, listen: false)
                        .currentIndex = 3;

                    Editprofile();
                  }
                },
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.green,
                  backgroundColor: Color(0xFF5F5151),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
