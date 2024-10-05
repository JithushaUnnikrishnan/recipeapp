import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/bottomnavigation.dart';

import 'customwidget/button.dart';
import 'customwidget/textfeild.dart';
import 'login.dart';

class Signup_re extends StatefulWidget {
  const Signup_re({super.key});

  @override
  State<Signup_re> createState() => _Signup_reState();
}

class _Signup_reState extends State<Signup_re> {
  final formkey = GlobalKey<FormState>();
  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  Future<dynamic> ReciSignup() async {
    await FirebaseFirestore.instance.collection("RecipeSign").add({
      "name": name.text,
      "Phone": phone.text,
      "email": email.text,
      "password": password.text,
      "path":
          "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=",
    });
    print("success");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF050505), Color(0xFF3B3B3B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height * .02),
                      Text(
                        "SIGNUP",
                        style: GoogleFonts.kavoon(
                            fontSize: 50, color: Color(0xFFEEF217)),
                      ),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * .015),
                      Textfeildd(
                        type: TextInputType.name,
                        controller: name,
                        text: "Name",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Empty";
                          }
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * .015),
                      Textfeildd(
                        type:TextInputType.number,
                        controller: phone,
                        text: "Phone",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Phone number is required";
                          } else if (value.length != 10) {
                            return "Enter a valid 10-digit phone number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * .015),
                      Textfeildd(
                        type: TextInputType.emailAddress,
                          controller: email,
                        validator: (value) {

                          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                          if (value!.isEmpty) {
                            return "Empty";
                          } else if (!emailRegex.hasMatch(value)) {
                            return "Enter a valid email (e.g. email@gmail.com)";
                          }
                        },
                        text: "Email",),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * .015),
                      Textfeildd(
                          type: TextInputType.visiblePassword,
                          controller: password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters long";
                          }
                          return null;
                        },
                        text: "password",
                      ),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * .055),
                      Center(
                          child: SubmitButton(
                              text: "Submit",
                              onPressed: () {
                                if (formkey.currentState!.validate()) {
                                  ReciSignup();
                                }
                              })),
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * .035),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Alredy you have an account?",
                            style: GoogleFonts.roboto(
                                fontSize: 16, color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              "Login",
                              style: GoogleFonts.roboto(
                                  color: Color(0xFFEEF217),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.4), // Add space at the bottom
                    ],
                  ),
                ),
              ),
              // Positioned(
              //     top: 480,
              //     left: 0,
              //     child: Container(
              //       height: 407,
              //       width: 250,
              //       decoration: BoxDecoration(
              //           image: DecorationImage(
              //               image: AssetImage("assets/signup_reci.png"),
              //               fit: BoxFit.cover)),
              //     ))
            ],
          ),
        ),
      ),
    );
  }
}
