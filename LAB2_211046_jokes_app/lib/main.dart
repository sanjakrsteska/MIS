import 'package:flutter/material.dart';
import 'package:jokes_app/screens/categories.dart';
import 'package:jokes_app/screens/category_jokes.dart';
import 'package:jokes_app/screens/random_joke.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Jokes',
      initialRoute: '/',
      routes : {
        '/': (context) => const Categories(),
        '/category-jokes' : (context) => const CategoryJokes(),
        '/random-joke': (context) => const RandomJoke()
      }
    );
  }

}

