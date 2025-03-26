import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
          return Text('Pass');
        },
      ),
    );
  }
}
