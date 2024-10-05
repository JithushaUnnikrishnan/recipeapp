import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/login.dart';
import 'package:recipe/signup.dart';

class Second extends StatefulWidget {
  const Second({super.key});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(children: [
          Opacity(
            opacity: 0.35,
            child: Container( height: double.infinity,
              width: double.infinity,
              child: Image(
                image: AssetImage(
                  "assets/bck.jpg",
                ),

                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 350,left: 110,
            child: InkWell(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup_re()));},
              child: Container(
                child: Center(child: Text("Signup",style: GoogleFonts.kavoon(fontSize: 25),)),
                height: 50,width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xFFEEF217),
                ),
              ),
            ),
          ),
          Positioned(
            top: 410,left: 190,
              child: Text("OR",style: GoogleFonts.kablammo(fontSize: 30,color: Colors.white),)),
          Positioned(
            top: 470,left: 110,
            child: InkWell(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));},
              child: Container(
                child: Center(child: Text("Login",style: GoogleFonts.kavoon(fontSize: 25),)),
                height: 50,width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(0xFFEEF217),
                ),
              ),
            ),
          )
        ],),
      ),
    );
  }
}
