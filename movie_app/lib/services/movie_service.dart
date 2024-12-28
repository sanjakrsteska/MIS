import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie_model.dart';

class MovieService {
  final String _apiKey = 'e300be3b28dec2735114eb7626766a55';

  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=1'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
  Future<List<Movie>> fetchMoviesByCategory(String category) async {
    final url = '$_baseUrl/movie/$category?api_key=$_apiKey&language=en-US&page=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> fetchMoviesByGenre(String genreId) async {
    final url = '$_baseUrl/discover/movie?api_key=$_apiKey&language=en-US&with_genres=$genreId&page=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> fetchTopRatedMovies() async {
    return fetchMoviesByCategory('top_rated');
  }

  Future<List<Movie>> fetchUpcomingMovies() async {
    return fetchMoviesByCategory('upcoming');
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    return fetchMoviesByCategory('now_playing');
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = '$_baseUrl/search/movie?api_key=$_apiKey&language=en-US&query=$query&page=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      print(data.map((json) => Movie.fromJson(json)).toList());
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
