import 'package:flutter/material.dart';

class MovieReleaseDate extends StatelessWidget {
  final String releaseDate;

  const MovieReleaseDate({Key? key, required this.releaseDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Release Date: $releaseDate",
      style: TextStyle(color: Colors.white70, fontSize: 16),
    );
  }
}
