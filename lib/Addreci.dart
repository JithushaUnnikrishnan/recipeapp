import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/myreci.dart';
import 'package:shared_preferences/shared_preferences.dart';

class addreci extends StatefulWidget {
  const addreci({super.key});

  @override
  State<addreci> createState() => _addreciState();
}

class _addreciState extends State<addreci> {

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
  final formkey = GlobalKey<FormState>();
  var reci_name = TextEditingController();
  var time = TextEditingController();
  var ingredients = TextEditingController();
  var category = TextEditingController();
  var servings = TextEditingController();
  var description = TextEditingController();
  List<String> categorylist = ["dessert", "appetizers", "maincourse"];
  String? selectedvalue;

  File? _image;
  bool isLoading = false;


  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  Future<void> Addreci() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('recipe_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_image!);


      final imageUrl = await ref.getDownloadURL();


      await FirebaseFirestore.instance.collection("Addrecipe").add({
        "reci_name": reci_name.text,
        "time": time.text,
        "ingredients": ingredients.text,
        "category": selectedvalue,
        "servings": servings.text,
        "description": description.text,
        "image_url": imageUrl,
        "user_id":ID,
      });


      Navigator.push(context, MaterialPageRoute(builder: (context) => MyRecii()));
    } catch (e) {
      print('Error uploading recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload recipe')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Add Recipe",
              style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recipe Name",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                TextFormField(style: TextStyle(color: Colors.white),
                  controller: reci_name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Empty";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[800],
                      hintText: "Enter recipe name"),
                ),
                SizedBox(height: 16),
                Text(
                  "Cooking Time",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                TextFormField(style: TextStyle(color: Colors.white),
                  controller: time,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Empty";
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[800],
                      hintText: "Select cooking time"),
                ),
                SizedBox(height: 16),
                Text(
                  "Ingredients",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                TextFormField(style: TextStyle(color: Colors.white),
                  controller: ingredients,
                  validator: (value){if(value!.isEmpty){return "Empty";}},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[800],
                      hintText: "Enter ingredients (comma-separated)"),
                ),
                SizedBox(height: 16),
                Text(
                  "Description",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                TextFormField(style: TextStyle(color: Colors.white),
                  controller: description,
                  validator: (value){if(value!.isEmpty){return "Empty";}},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[800],
                      hintText: "Enter Description"),
                ),
                SizedBox(height: 16),
                Text(
                  "Category",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        width: 360,
                        height: 69,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey)),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            elevation: 0,
                            // dropdownColor: Colors.grey.shade100,
                            hint: const Text("Gender"),
                            underline: const SizedBox(),
                            value: selectedvalue,
                            items: categorylist.map((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            onChanged: (newvalue) {
                              setState(() {
                                selectedvalue = newvalue;
                                print(selectedvalue);
                              });
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 10)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Servings",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                TextFormField(style: TextStyle(color: Colors.white),
                  controller: servings,
                  validator: (value){if(value!.isEmpty){return "Empty";}},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey[800],
                      hintText: "Enter Serves" ),
                ),
                SizedBox(height: 16),
                Text(
                  "Recipe Image",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: _getImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5F5151),
                  ),
                  child: Text(_image == null ? "Select Image" : "Image Selected",
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
                SizedBox(height: 40),
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    if(formkey.currentState!.validate()){
                      Addreci();
                    }
                  },
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Add Recipe", style: GoogleFonts.poppins(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5F5151),
                      ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
