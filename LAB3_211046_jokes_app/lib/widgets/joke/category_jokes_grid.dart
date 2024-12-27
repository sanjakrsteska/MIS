import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/joke_model.dart';

class CategoryJokesGrid extends StatefulWidget {
  final List<Joke> jokes;
  const CategoryJokesGrid({super.key, required this.jokes});

  @override
  State<CategoryJokesGrid> createState() => _CategoryJokesGridState();
}

class _CategoryJokesGridState extends State<CategoryJokesGrid> {
  Map<String, bool> _favoriteStatus = {};

  Future<bool> _isFavorite(Joke joke) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final favoriteDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(joke.id.toString())
            .get();
        return favoriteDoc.exists;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    return false;
  }
  Future<void> _toggleFavorite(Joke joke) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(joke.id.toString());

        final favoriteDoc = await docRef.get();

        if (favoriteDoc.exists) {
          await docRef.delete();
          setState(() {
            _favoriteStatus[joke.id.toString()] = false; 
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joke removed from favorites')));
        } else {
          await docRef.set({
            'setup': joke.setup,
            'punchline': joke.punchline,
            'type': joke.type,
          });
          setState(() {
            _favoriteStatus[joke.id.toString()] = true; 
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joke added to favorites')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in first')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1 / 1.2,
      ),
      shrinkWrap: true,
      itemCount: widget.jokes.length,
      itemBuilder: (context, index) {
        var joke = widget.jokes[index];
        return GestureDetector(
          onTap: () {},
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      joke.setup,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    joke.punchline,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  FutureBuilder<bool>(
                    future: _isFavorite(joke),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return IconButton(
                          icon: const Icon(Icons.error),
                          onPressed: () {},
                        );
                      } else {
                        bool isFavorite = _favoriteStatus[joke.id.toString()] ?? snapshot.data ?? false;
                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () => _toggleFavorite(joke),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

