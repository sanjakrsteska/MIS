import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final String imageUrl;

  const MoviePoster({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            imageUrl.isNotEmpty
                ? 'https://image.tmdb.org/t/p/w500$imageUrl'
                : 'https://img.freepik.com/premium-vector/click-movie-logo-vector_18099-258.jpg?w=360',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
