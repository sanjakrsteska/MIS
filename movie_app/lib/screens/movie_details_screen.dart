import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/favourite_movies_service.dart';
import '../widgets/movie_details/movie_overview_widget.dart';
import '../widgets/movie_details/movie_poster_widget.dart';
import '../widgets/movie_details/movie_rating_widget.dart';
import '../widgets/movie_details/movie_release_date_widget.dart';
import '../widgets/movie_details/movie_title_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final FavouriteMoviesService _favoritesService = FavouriteMoviesService();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    List<Movie> favorites = await _favoritesService.getFavorites();
    setState(() {
      isFavorite = favorites.any((movie) => movie.id == widget.movie.id);
    });
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await _favoritesService.removeFavorite(widget.movie);
    } else {
      await _favoritesService.addFavorite(widget.movie);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.movie.title, style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoviePoster(imageUrl: widget.movie.backdropPath),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieTitle(title: widget.movie.title),
                  SizedBox(height: 8),
                  MovieReleaseDate(releaseDate: widget.movie.releaseDate),
                  SizedBox(height: 8),
                  MovieRating(voteAverage: widget.movie.voteAverage),
                  SizedBox(height: 16),
                  MovieOverview(overview: widget.movie.overview),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
