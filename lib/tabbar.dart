import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/desserts.dart';
import 'package:recipe/home.dart';

import 'package:recipe/maincourse.dart';
import 'package:recipe/appetizers.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  String searchQuery = "";

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
              labelColor: Colors.white,
              dividerColor: Colors.black,
              // unselectedLabelColor:Colors.white ,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Color(0xFF5F5151),
              ),
              tabs: [
                Container(
                  height: 40,
                  width: 100,
                  child: Tab(
                    child: Text(
                      "All",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  child: Tab(
                    child: Text(
                      "Main Course",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  child: Tab(
                    child: Text(
                      "Desserts",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  width: 100,
                  child: Tab(
                    child: Text(
                      "Appetizers",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ]),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          toolbarHeight: 180,
          title: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 290,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/dessert_cheesecake.jpg"),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.red,
                ),
              ),
              Positioned(
                top: 100,
                child: Container(
                  width: 355,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF5F5151), Color(0xFF5F5151)],
                        begin: Alignment.bottomLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    onChanged:
                        updateSearchQuery, // Update search query on input
                    decoration: InputDecoration(
                      hintText: "Find the recipes",
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * .01,
              ),
              Positioned(
                top: 170,
                child: Text(
                  "Explore",
                  style: GoogleFonts.roboto(
                      fontSize: 30,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: TabBarView(children: [
              Homee(searchQuery: searchQuery),
              Maincourse(searchQuery: searchQuery),
              Dessert(searchQuery: searchQuery),
              Appetizer(searchQuery: searchQuery)
            ])),
          ],
        ),
      ),
    );
  }
}
