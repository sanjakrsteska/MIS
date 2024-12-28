import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model.dart';

class FavouriteMoviesService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<List<Movie>> getFavorites() async {
    try {
      final doc = await _firestore.collection('favorites').doc(_userId).get();
      if (doc.exists) {
        List<Movie> favorites = [];
        for (var movieData in doc['movies']) {
          favorites.add(Movie.fromMap(movieData));
        }
        return favorites;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching favorites: $e");
      return [];
    }
  }

  Future<void> addFavorite(Movie movie) async {
    try {
      final docRef = _firestore.collection('favorites').doc(_userId);

      await docRef.set({
        'movies': FieldValue.arrayUnion([movie.toMap()])
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error adding to favorites: $e");
    }
  }

  Future<void> removeFavorite(Movie movie) async {
    try {
      final docRef = _firestore.collection('favorites').doc(_userId);

      await docRef.set({
        'movies': FieldValue.arrayRemove([movie.toMap()])
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error removing from favorites: $e");
    }
  }
}
