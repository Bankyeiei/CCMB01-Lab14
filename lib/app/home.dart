import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '/app/ui/food_container.dart';
import '/data/food.dart';
import '/data/data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static var foods = FirebaseFirestore.instance.collection('foods');

  Stream<QuerySnapshot> getFoods() {
    return foods.snapshots();
  }

  Future<void> addFood() async {
    await deleteAllFood();
    List<Food> foodList =
        foodJson['thai_foods']!
            .map((element) => Food.fromJson(element))
            .toList();
    for (Food food in foodList) {
      await foods.add({
        'chef': {'name': food.chefName, 'image_url': food.chefImageUrl},
        'menu_name': food.menuName,
        'ingredients': food.ingredients,
        'image_url': food.foodImageUrl,
        'is_favorite': food.isFavorite,
      });
    }
  }

  Future<void> deleteAllFood() async {
    final snapshot = await foods.get();
    for (var doc in snapshot.docs) {
      await foods.doc(doc.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(onPressed: () => addFood(), icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: getFoods(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  Text('Error');
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 20),
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
          ),
        ],
      ),
    );
  }
}
