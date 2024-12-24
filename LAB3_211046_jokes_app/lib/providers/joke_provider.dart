// import 'package:flutter/material.dart';
// import 'package:jokes_app/models/joke_model.dart';
// import 'package:jokes_app/services/api_service.dart';

// class JokeProvider extends ChangeNotifier {
//   final ApiService _jokeService = ApiService(); // Your joke fetching service
//   late List<Joke> jokes;

//   JokeProvider() {
//     jokes = _jokeService.getCategoryJokes(); // Fetch jokes from your service
//   }

//   // Get all jokes
//   List<Joke> get allJokes => jokes;

//   // Toggle the favorite status of a joke
//   void toggleFavorite(Joke joke) {
//     joke.isFavorite = !joke.isFavorite;
//     notifyListeners();  // Notify listeners to update the UI
//   }

//   // Add a new joke to the list (for example, after fetching new jokes)
//   void addJoke(Joke joke) {
//     jokes.add(joke);
//     notifyListeners();
//   }

//   // Remove a joke from the list (for example, when a joke is deleted)
//   void removeJoke(Joke joke) {
//     jokes.remove(joke);
//     notifyListeners();
//   }

//   // Fetch jokes from the service (you can implement error handling as needed)
//   Future<void> fetchJokes() async {
//     try {
//       jokes = await _jokeService.getJokes();
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching jokes: $e');
//     }
//   }
// }
