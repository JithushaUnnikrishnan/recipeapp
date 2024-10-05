import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/favorite.dart';

import 'package:recipe/profile.dart';
import 'package:recipe/tabbar.dart';

import 'package:recipe/Addreci.dart';

import 'models/navigationmodel.dart';




class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({super.key});

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {

  @override

  Widget build(BuildContext context) {
    final navigationModel = Provider.of<NavigationModel>(context);
    List<Widget> Screen = [
      Tabbar(),
      addreci(),
      Favorites(),
      Profile(),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      body:  Screen[navigationModel.currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomAppBar(
          surfaceTintColor: Colors.black,
          color: Color(0xFF5F5151),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildIconButton(Icons.home, () {

                  navigationModel.currentIndex  = 0;

              }),
              buildIconButton(Icons.add, () {

                  navigationModel.currentIndex  = 1;

              }),

              buildIconButton(Icons.person, () {

                  navigationModel.currentIndex  = 3;

              }),
            ],
          ),
        ),
      ),
    );
  }

  IconButton buildIconButton(IconData icon, VoidCallback onpressed) =>
      IconButton(
        onPressed: onpressed,
        icon: Icon(icon),
        color: Colors.white,
      );
}
