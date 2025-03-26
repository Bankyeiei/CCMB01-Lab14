import 'package:flutter/material.dart';

import '/app/ui/food_detail.dart';
import '/data/food.dart';

class FoodContainer extends StatelessWidget {
  final Food food;
  final String id;
  const FoodContainer({super.key, required this.food, required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodDetail(food: food, id: id),
            ),
          ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 8, offset: Offset(0, 8)),
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.menuName,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(thickness: 3, endIndent: 30),
                    Text(
                      food.chefName,
                      maxLines: 1,
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    Text(
                      'ส่วนประกอบ :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(food.ingredients, maxLines: 3),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: SizedBox(
                height: double.infinity,
                child: Hero(
                  tag: food.menuName,
                  child: Image.network(
                    food.foodImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Color(0xFFEEEEEE),
                          child: Icon(Icons.error, size: 32, color: Colors.red),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
