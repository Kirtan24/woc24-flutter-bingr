import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String? _tmdbApiKey = dotenv.env['TMDB_API_KEY'];
  final String _baseUrlOmdb = 'https://www.omdbapi.com';
  final String? _omdbApiKey = dotenv.env['OMDB_API_KEY'];

  Future<Map<String, dynamic>?> fetchMovieDetails(
      int movieId, String mediaType) async {
    try {
      // Fetch all data concurrently
      final movieDetailsFuture = _fetchMovieDetails(movieId, mediaType);
      final creditsFuture = _fetchMovieCredits(movieId, mediaType);
      final videosFuture = _fetchMovieVideos(movieId, mediaType);
      final recommendationsFuture =
          _fetchMovieRecommendations(movieId, mediaType);

      // Await all API responses
      final movieDetails = await movieDetailsFuture;
      final credits = await creditsFuture;
      final videos = await videosFuture;
      final recommendations = await recommendationsFuture;

      // Extract IMDb ID and fetch ratings (if available)
      String? imdbId = movieDetails?["imdb_id"];
      Map<String, dynamic>? ratings;
      if (imdbId != null && imdbId.isNotEmpty) {
        ratings = await _fetchIMDbRatings(imdbId);
      }

      // Create combined JSON response
      final combinedJson = {
        "movieDetails": movieDetails,
        "ratings": ratings,
        "credits": credits,
        "trailerUrl": videos,
        "recommendations": recommendations,
      };

      return combinedJson;
    } catch (error) {
      print("❌ Error fetching movie details: $error");
      return null;
    }
  }

  /// Helper function to search movie
  Future<List<dynamic>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final url =
        '$_baseUrl/search/multi?query=$query&include_adult=false&language=en-US&page=1&api_key=$_tmdbApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'] ?? [];
      } else {
        print("⚠️ Search API Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (error) {
      print("❌ Error fetching search results: $error");
      return [];
    }
  }

  /// Helper function to fetch movie details
  Future<Map<String, dynamic>?> _fetchMovieDetails(
      int movieId, String mediaType) async {
    final url =
        '$_baseUrl/$mediaType/$movieId?api_key=$_tmdbApiKey&language=en-US';
    return await _fetchData(url, "Movie Details");
  }

  /// Helper function to fetch movie credits (cast & crew)
  Future<Map<String, dynamic>?> _fetchMovieCredits(
      int movieId, String mediaType) async {
    final url =
        '$_baseUrl/$mediaType/$movieId/credits?api_key=$_tmdbApiKey&language=en-US';
    return await _fetchData(url, "Movie Credits");
  }

  /// Helper function to fetch IMDb ratings
  Future<Map<String, dynamic>?> _fetchIMDbRatings(String imdbId) async {
    final url = '$_baseUrlOmdb/?i=$imdbId&apikey=$_omdbApiKey';
    return await _fetchData(url, "IMDb Ratings");
  }

  /// Helper function to fetch movie videos (trailers, teasers)
  Future<String?> _fetchMovieVideos(int movieId, String mediaType) async {
    final url =
        '$_baseUrl/$mediaType/$movieId/videos?api_key=$_tmdbApiKey&language=en-US';
    final response = await _fetchData(url, "Movie Videos");

    if (response == null || !response.containsKey('results')) {
      return null; // No videos found
    }

    List<dynamic>? videos = response['results'];

    if (videos == null || videos.isEmpty) {
      return null; // No videos available
    }

    // Look for YouTube Trailer first
    var trailer = videos.firstWhere(
      (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
      orElse: () => null,
    );

    // Return only the trailer URL if found, otherwise null
    return trailer != null ? trailer['key'] : null;
  }

  /// Helper function to fetch recommended movies/shows
  Future<Map<String, dynamic>?> _fetchMovieRecommendations(
      int movieId, String mediaType) async {
    final url =
        '$_baseUrl/$mediaType/$movieId/recommendations?api_key=$_tmdbApiKey&language=en-US&page=1';
    return await _fetchData(url, "Movie Recommendations");
  }

  /// Generic function to fetch data from an API with error handling
  Future<Map<String, dynamic>?> _fetchData(String url, String apiName) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData.isNotEmpty ? jsonData : null;
      } else {
        print(
            "⚠️ $apiName API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (error) {
      print("❌ Exception in $apiName API: $error");
      return null;
    }
  }
}
