import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/editprofile.dart';
import 'package:recipe/favorite.dart';
import 'package:recipe/myreci.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  PickedFile? _image;
  bool isloading = false;
  Future<void> _getImage() async {
    setState(() {
      isloading = true;
    });
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = PickedFile(pickedFile.path);
        print("picked image");
        update();
      } else {
        print('No image selected.');
      }
    });
  }
  Future<void> update() async {
    try {
      if (_image != null) {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(File(_image!.path));

        final imageURL = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('RecipeSign')
            .doc(ID)
            .update({
          'path': imageURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
        setState(() {
          isloading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating profile'),
        ),
      );
    }
  }
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

  DocumentSnapshot? reci;

  Getfirebase() async {
    reci = await FirebaseFirestore.instance
        .collection("RecipeSign")
        .doc(ID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Getfirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                color: Colors.purple,
              ));
        }
        if (snapshot.hasError) {
          return Text("Error${snapshot.error}");
        }
        return Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  isloading
                      ? CircularProgressIndicator(
                    color: Color(0xFF93B4D1),
                  )
                  : Center(
                    child: Stack(
                      children: [
                        ClipOval(
                          child: Image.network(
                            reci!["path"], // Replace with your profile image
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                            top: 60,left: 59,
                            child: IconButton(onPressed: (){
                             setState(() {
                               _getImage();
                             });;
                            }, icon: Icon(Icons.camera_alt,color: Colors.green.shade400,size: 40,)))
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    reci!["name"],
                    style: GoogleFonts.russoOne(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(reci!["Phone"],style: GoogleFonts.poppins(fontSize: 16,color: Colors.grey[400]),),
                      Container(
                        height: 20, // Adjust the height as needed
                        width: 2, // Width of the vertical line
                        color: Colors.grey[400], // Color of the vertical line
                        margin: EdgeInsets.symmetric(horizontal: 10), // Space around the line
                      ),
                      Text(
                        "Recipe Enthusiast",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  buildButton("Edit Profile", Icons.edit,context,EditProfile(id:reci!.id)),
                  SizedBox(height: 16),
                  buildButton("My Recipes", Icons.receipt,context,MyRecii()),
                  SizedBox(height: 16),
                  buildButton("Favorites", Icons.favorite,context,Favorites()),
                  SizedBox(height: 16),
                  buildButton("Logout", Icons.logout,context,First()),
                  SizedBox(height: 40),
                  Text(
                    "Version 1.0.0",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildButton(String title, IconData icon,BuildContext context, Widget targetPage) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF5F5151), // Button color
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
