import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/app/ui/food_container.dart';
import '/data/food.dart';
import '/data/data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static var foods = FirebaseFirestore.instance.collection('foods');

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  List<String> generateKeywords(String text) {
    text = text.toLowerCase();
    final List<String> keywords = [];
    for (int i = 0; i < text.length; i++) {
      for (int j = i + 1; j <= text.length; j++) {
        keywords.add(text.substring(i, j));
      }
    }
    return [...keywords.toSet(), ''];
  }

  Stream<QuerySnapshot> getFoods(String keyword) {
    return HomeScreen.foods
        .where('search_keywords', arrayContains: keyword.toLowerCase())
        .snapshots();
  }

  Future<void> resetFood() async {
    await deleteAllFood();
    List<Food> foodList =
        foodJson['thai_foods']!
            .map((element) => Food.fromJson(element))
            .toList();
    for (Food food in foodList) {
      await HomeScreen.foods.add({
        'chef': {'name': food.chefName, 'image_url': food.chefImageUrl},
        'menu_name': food.menuName,
        'ingredients': food.ingredients,
        'image_url': food.foodImageUrl,
        'is_favorite': food.isFavorite,
        'search_keywords': generateKeywords(food.menuName),
      });
    }
  }

  Future<void> deleteAllFood() async {
    final snapshot = await HomeScreen.foods.get();
    for (var doc in snapshot.docs) {
      await HomeScreen.foods.doc(doc.id).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
          actions: [
            IconButton(
              tooltip: 'Reset',
              onPressed:
                  () => showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Are you sure to reset?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                resetFood();
                                Navigator.pop(context);
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        ),
                  ),
              icon: Icon(Icons.refresh, size: 24),
            ),
            SizedBox(width: 10),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: getFoods(searchController.text),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      Text('Error');
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 20),
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
                        return FoodContainer(
                          food: foodList[index],
                          id: docs[index].id,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
