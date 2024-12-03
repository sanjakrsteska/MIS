  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:jokes_app/services/api_service.dart';
  import 'package:jokes_app/widgets/joke/category_jokes_grid.dart';

  import '../models/joke_model.dart';

  class CategoryJokes extends StatefulWidget {
    const CategoryJokes({super.key});

    @override
    State<CategoryJokes> createState() => _CategoryJokesState();
  }

  class _CategoryJokesState extends State<CategoryJokes> {
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
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context, '/random-joke');
            }, icon: const Icon(Icons.casino, color: Colors.white, size: 24)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: jokes.isEmpty
              ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching jokes
              : CategoryJokesGrid(jokes: jokes), // Display jokes in the grid after loading
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
  }
