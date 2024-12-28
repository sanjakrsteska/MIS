import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/favourite_movies_service.dart';

class FavouriteMoviesScreen extends StatefulWidget {
  @override
  _FavouriteMoviesScreenState createState() => _FavouriteMoviesScreenState();
}

class _FavouriteMoviesScreenState extends State<FavouriteMoviesScreen> {
  final FavouriteMoviesService _favoritesService = FavouriteMoviesService();
  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    List<Movie> favorites = await _favoritesService.getFavorites();
    setState(() {
      favoriteMovies = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Favorite Movies', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0
      ),
      body: favoriteMovies.isEmpty
          ? Center(
        child: Text(
          "No favorite movies yet.",
          style: TextStyle(color: Colors.white),
        ),
      )
          : _buildMovieGrid(),
    );
  }

  Widget _buildMovieGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: favoriteMovies.length,
      itemBuilder: (context, index) {
        final movie = favoriteMovies[index];
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(
                  movie.posterPath.isNotEmpty
                      ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                      : 'https://img.freepik.com/premium-vector/click-movie-logo-vector_18099-258.jpg?w=360',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
      },
    );
  }
}
