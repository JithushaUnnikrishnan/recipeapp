import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/second.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Image(
              image: AssetImage(
                "assets/clear.jpg",
              ),
              height: 500,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Positioned(
                top: 450,
                child: Text(
                  "COOK LIKE A \nCHEIF",
                  style:
                      GoogleFonts.kablammo(fontSize: 50, color: Colors.white),
                )),
            Positioned(
              top: 710,left: 110,
              child: InkWell(onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Second()));},
                child: Container(
                  child: Center(child: Text("Get Started",style: GoogleFonts.kaushanScript(fontSize: 25),)),
                  height: 50,width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Color(0xFFEEF217),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
