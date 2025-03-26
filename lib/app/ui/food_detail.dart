import 'package:flutter/material.dart';

import '/data/food.dart';

class FoodDetail extends StatefulWidget {
  final Food food;
  const FoodDetail({super.key, required this.food});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.food.menuName),
        actions: [
          IconButton(
            icon:
                widget.food.isFavorite
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_outline),
            onPressed: () {
              widget.food.clickLike();
              setState(() {});
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Hero(
                tag: widget.food.menuName,
                child: Image.network(
                  widget.food.foodImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 200,
                        color: Color(0xFFEEEEEE),
                        child: Icon(Icons.error, size: 32, color: Colors.red),
                      ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food.menuName,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Divider(
                      thickness: 3,
                      endIndent: 0.1 * MediaQuery.sizeOf(context).width,
                    ),
                    Text(
                      "จัดทำโดย :",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          child: Image.network(
                            widget.food.chefImageUrl,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.person),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.food.chefName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "ส่วนประกอบสำคัญ :",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      widget.food.ingredients,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ย้อนกลับ"),
            ),
          ],
        ),
      ),
    );
  }
}
