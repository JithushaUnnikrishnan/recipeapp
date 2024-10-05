import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Textfeildd extends StatelessWidget {
  final String text;
  final  type;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  const Textfeildd({super.key,required this.text,required this.validator,required this.controller,required this.type});


  @override
  Widget build(BuildContext context) {
    return TextFormField(validator: validator,
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintText: text,
          hintStyle: GoogleFonts.roboto(
            color: Colors.grey,
            fontSize: 20,
          )),
      style: GoogleFonts.roboto(
        color: Colors.white, // Input text color
        fontSize: 20, // Input text size
      ),
    );
  }
}
