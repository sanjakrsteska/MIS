import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/joke_model.dart';

class FavouriteJokes extends StatefulWidget {
  const FavouriteJokes({super.key});

  @override
  State<FavouriteJokes> createState() => _FavouriteJokesState();
}

class _FavouriteJokesState extends State<FavouriteJokes> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Joke> favoriteJokes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getFavoriteJokes();
  }

  Future<void> _getFavoriteJokes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final favoriteDocs = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .get();

        setState(() {
          favoriteJokes = favoriteDocs.docs.map((doc) {
            return Joke(
              id: int.parse(doc.id),
              setup: doc['setup'],
              punchline: doc['punchline'],
              type: doc['type'],
            );
          }).toList();
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching favorite jokes: $e');
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
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
            icon: const Icon(Icons.casino, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/random-joke');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : favoriteJokes.isEmpty
            ? const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.deepPurple,
                  size: 48,
                ),
                SizedBox(height: 16),
                const Text(
                  'No favorite jokes found.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Start adding jokes to your favorites!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        )
            : ListView.builder(
          itemCount: favoriteJokes.length,
          itemBuilder: (context, index) {
            final joke = favoriteJokes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  joke.setup,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  joke.punchline,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
