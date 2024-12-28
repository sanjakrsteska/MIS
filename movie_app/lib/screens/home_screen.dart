import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screens/favourite_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  bool isSearching = false;

  List<Movie> carouselMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> nowPlayingMovies = [];
  List<Movie> upcomingMovies = [];
  List<Movie> searchResults = [];

  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      // Fetch different movie categories
      List<Movie> fetchedPopularMovies = await movieService.fetchPopularMovies();
      List<Movie> fetchedNowPlayingMovies = await movieService.fetchNowPlayingMovies();
      List<Movie> fetchedUpcomingMovies = await movieService.fetchUpcomingMovies();

      setState(() {
        carouselMovies = fetchedPopularMovies.take(3).toList();
        popularMovies = fetchedPopularMovies.take(9).toList();
        nowPlayingMovies = fetchedNowPlayingMovies.take(9).toList();
        upcomingMovies = fetchedUpcomingMovies.take(9).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching movies: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchMovies(String query) async {
    print("search query $query");
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return;
    }

    try {
      setState(() {
        isSearching = true;
        isLoading = true;
      });

      final results = await movieService.searchMovies(query);
      print("Search results: $results");

      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching movies: $e');
      setState(() {
        isLoading = false;
        searchResults.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextField(
          controller: _searchController,
          onChanged: searchMovies,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        )
            : Text('Discover', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // Navigate to FavoritesScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavouriteMoviesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  _searchController.clear();
                  searchResults.clear();
                } else {
                  isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
             FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: isSearching
            ? _buildSearchResults()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCarousel(),
            SizedBox(height: 20),

            _buildSectionTitle('Popular Movies'),
            _buildHorizontalMovieList(popularMovies),

            SizedBox(height: 20),

            _buildSectionTitle('Now Playing'),
            _buildHorizontalMovieList(nowPlayingMovies),

            SizedBox(height: 20),

            _buildSectionTitle('Upcoming'),
            _buildHorizontalMovieList(upcomingMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return searchResults.isEmpty
        ? Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No movies found.',
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Search Results'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.65,
            ),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final movie = searchResults[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: Container(
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: carouselMovies.length,
            itemBuilder: (context, index) {
              final movie = carouselMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          movie.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: carouselMovies.length,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 24,
            activeDotColor: Colors.white,
            dotColor: Colors.grey,
            spacing: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHorizontalMovieList(List<Movie> movies) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movie),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: EdgeInsets.symmetric(horizontal: 8),
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
            ),
          );
        },
      ),
    );
  }
}
