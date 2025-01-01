# Movie App - Sanja Krsteska 211046

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Key Components](#key-components)
  - [FavouriteMoviesScreen](#favouritemoviesscreen)
  - [MovieDetailScreen](#moviedetailscreen)
  - [Movie Widgets](#movie-widgets)
- [Services](#services)

---

## Introduction
This Flutter-based Movie App allows users to browse movies, view detailed information, and manage their favorite movies. The app interacts with a movie API for dynamic data and supports a persistent list of user-selected favorite movies.

---

## Features
- Display a grid of favorite movies.
- Detailed movie information screen with the ability to mark movies as favorites.
- Persistent storage for favorite movies using the `FavouriteMoviesService`.
- Modular UI design with reusable widgets for better code maintainability.
- Clean and responsive design tailored for cinematic themes.

---

## Key Components

### FavouriteMoviesScreen
This screen displays a grid of the user's favorite movies.

#### Key Code Snippets:
```dart
Future<void> _loadFavorites() async {
  List<Movie> favorites = await _favoritesService.getFavorites();
  setState(() {
    favoriteMovies = favorites;
  });
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
```

---

### MovieDetailScreen
This screen provides detailed information about a selected movie and allows users to toggle its favorite status.

#### Features:
- Displays movie details: title, release date, rating, and overview.
- Favorite toggle button updates the movie's status persistently.

#### Key Code Snippets:
```dart
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
```

---

### Movie Widgets

#### MoviePoster
Displays the movie poster image.
```dart
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
```

#### MovieOverview
Displays the movie's overview.
```dart
class MovieOverview extends StatelessWidget {
  final String overview;

  const MovieOverview({Key? key, required this.overview}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Overview",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          overview,
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }
}
```

---

## Services

### FavouriteMoviesService
Provides methods for managing favorite movies.
- `getFavorites()`: Retrieves the list of favorite movies.
- `addFavorite(movie)`: Adds a movie to the favorites list.
- `removeFavorite(movie)`: Removes a movie from the favorites list.

---


