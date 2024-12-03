import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jokes_app/services/api_service.dart';
import 'package:jokes_app/widgets/category/category_grid.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();

}
  class _CategoriesState extends State<Categories> {
  List<String> categories = [];

  @override
  void initState() {
  super.initState();
  getCategoriesFromAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Jokes App", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [IconButton(onPressed: () {
          Navigator.pushNamed(context, '/random-joke');
        }, icon: const Icon(Icons.casino, color: Colors.white, size: 24))],
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: CategoryGrid(categories: categories)
      )
    );
  }

  void getCategoriesFromAPI() async {
    var response = await ApiService.getCategories();
    var data = List<String>.from(json.decode(response.body));
    setState(() {
      categories = data;
    });
  }
}