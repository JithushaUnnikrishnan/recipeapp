import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/view.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Favorites', style: GoogleFonts.russoOne(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Favorites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.purple),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No favorites added yet.", style: TextStyle(color: Colors.white)));
          }

          final favoriteRecipes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoriteRecipes.length,
            itemBuilder: (context, index) {
              final recipe = favoriteRecipes[index];

              return Card(
                color: Colors.grey[900],
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(recipe['image_url'], fit: BoxFit.cover, width: 100),
                  title: Text(recipe['reci_name'], style: GoogleFonts.poppins(color: Colors.white)),
                  subtitle: Text(
                    'Cooking Time: ${recipe['time']} \nServes: ${recipe['servings']}',
                    style: GoogleFonts.poppins(color: Colors.grey[400]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {

                      await FirebaseFirestore.instance.collection('Favorites').doc(recipe.id).delete();
                    },
                  ),
                  onTap: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPage(id: recipe.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
