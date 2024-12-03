import 'package:flutter/material.dart';
import '../../models/joke_model.dart';

class CategoryJokesGrid extends StatefulWidget {
  final List<Joke> jokes;
  const CategoryJokesGrid({super.key, required this.jokes});

  @override
  State<CategoryJokesGrid> createState() => _CategoryJokesGridState();
}

class _CategoryJokesGridState extends State<CategoryJokesGrid> {
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
          onTap: () {
          },
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
