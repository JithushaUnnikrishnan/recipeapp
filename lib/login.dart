import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipe/bottomnavigation.dart';
import 'package:recipe/signup.dart';
import 'package:recipe/customwidget/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customwidget/textfeild.dart';
import 'models/navigationmodel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  String ID = "";
  String dessert="";
  String maincourse="";
  String appetizers="";

  void ReciLog() async {
    final User = await FirebaseFirestore.instance
        .collection("RecipeSign")
        .where("email", isEqualTo: email.text)
        .where("password", isEqualTo: password.text)
        .get();
    if (User.docs.isNotEmpty) {
      ID = User.docs[0].id;

      SharedPreferences data = await SharedPreferences.getInstance();
      data.setString("Id", ID);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Bottomnavigation()
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red,
          content: Text(
        "Email or Password Invalid",
        style: TextStyle(color: Colors.white),
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      child: Scaffold(
        body: Container(
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
                  "LOGIN",
                  style: GoogleFonts.kavoon(
                      fontSize: 50, color: Color(0xFFEEF217)),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * .015),
                Textfeildd(
                    type: TextInputType.emailAddress,
                    controller: email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Empty";
                      }
                    },
                    text: "Email"),
                SizedBox(height: MediaQuery.sizeOf(context).height * .015),
                Textfeildd(
                  type: TextInputType.visiblePassword,
                    controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Empty";
                      }
                    },
                    text: "Password"),
                SizedBox(height: MediaQuery.sizeOf(context).height * .055),
                Center(
                    child: SubmitButton(
                        text: "Submit",
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            Provider.of<NavigationModel>(context, listen: false).currentIndex = 0;
                            ReciLog();
                          }
                        })),
                SizedBox(height: MediaQuery.sizeOf(context).height * .035),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create Account?",
                      style:
                          GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signup_re()));
                      },
                      child: Text(
                        "Signup",
                        style: GoogleFonts.roboto(
                            color: Color(0xFFEEF217),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
