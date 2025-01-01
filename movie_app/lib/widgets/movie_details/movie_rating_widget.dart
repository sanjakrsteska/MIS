import 'package:flutter/material.dart';

class MovieRating extends StatelessWidget {
  final double voteAverage;

  const MovieRating({Key? key, required this.voteAverage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Rating: ${voteAverage.toStringAsFixed(1)} / 10",
      style: TextStyle(color: Colors.white70, fontSize: 16),
    );
  }
}
