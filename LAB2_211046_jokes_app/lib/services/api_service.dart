import 'package:http/http.dart' as http;

class ApiService {
  static Future<http.Response> getCategories() async {
    var response = await http.get(Uri.parse("https://official-joke-api.appspot.com/types"));
    return response;
  }
  static Future<http.Response> getCategoryJokes(String category) async {
    var response = await http.get(Uri.parse("https://official-joke-api.appspot.com/jokes/$category/ten"));
    return response;
  }
  static Future<http.Response> getRandomJoke() async {
    var response = await http.get(Uri.parse("https://official-joke-api.appspot.com/random_joke"));
    return response;
  }
}

