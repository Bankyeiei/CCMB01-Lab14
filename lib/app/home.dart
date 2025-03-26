import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '/app/ui/food_container.dart';
import '/data/food.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final foods = FirebaseFirestore.instance.collection('foods');

  Stream<QuerySnapshot> getFoods() {
    return foods.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: StreamBuilder(
        stream: getFoods(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            Text('Error');
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final List<Food> foodList =
                  docs
                      .map(
                        (element) => Food.fromJson(
                          element.data() as Map<String, dynamic>,
                        ),
                      )
                      .toList();
              return FoodContainer(food: foodList[index]);
            },
          );
        },
      ),
    );
  }
}
