import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jokes_app/screens/favourite_jokes.dart';
import 'package:jokes_app/services/api_service.dart';
import 'package:jokes_app/widgets/joke/category_jokes_grid.dart';

import '../models/joke_model.dart';

class CategoryJokes extends StatefulWidget {
  const CategoryJokes({super.key});

  @override
  State<CategoryJokes> createState() => _CategoryJokesState();
}

class _CategoryJokesState extends State<CategoryJokes> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Joke> jokes = [];
  String category = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final category = ModalRoute.of(context)!.settings.arguments as String;
    getCategoryJokesFromAPI(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Jokes App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavouriteJokes()),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/random-joke');
            },
            icon: const Icon(Icons.casino, color: Colors.white, size: 24),
          ),
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white, size: 24),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: jokes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : CategoryJokesGrid(jokes: jokes),
      ),
    );
  }

  void getCategoryJokesFromAPI(String category) async {
    var response = await ApiService.getCategoryJokes(category);
    var data = json.decode(response.body) as List;
    setState(() {
      jokes = data.map((jokeJson) => Joke.fromJson(jokeJson)).toList();
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
