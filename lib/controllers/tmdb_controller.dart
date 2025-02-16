import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TMDBController {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String? _tmdbApiKey = dotenv.env['TMDB_API_KEY'];

  Future<List<dynamic>> getTrendingMoviesAndSeries() async {
    try {
      final moviesFuture = _fetchTrendingMovies();
      final List<dynamic> movies = await moviesFuture;
      final List<dynamic> trending = [
        ...movies.take(10),
      ];
      return trending;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<dynamic>> _fetchTrendingMovies() async {
    final url =
        '$_baseUrl/discover/movie?api_key=$_tmdbApiKey&include_adult=false&include_video=false&language=en-US&page=1&region=IN&sort_by=popularity.desc&with_origin_country=IN&vote_average.gte=5';

    final movies = await _fetchData(url);

    return movies.map((movie) => {...movie, 'media_type': 'movie'}).toList();
  }

  Future<List<dynamic>> _fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Map<String, dynamic>> getArtistDetails(int artistId) async {
    final url =
        '$_baseUrl/person/$artistId?api_key=$_tmdbApiKey&language=en-US';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch artist details');
    }
  }
}
