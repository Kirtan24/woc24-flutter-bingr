import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bingr/common/widgets/movie_card.dart';
import 'package:bingr/screens/details/movie_details.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Map<String, dynamic>> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  // Function to load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      favoriteMovies = favorites
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  // Function to remove a movie from favorites
  Future<void> removeFromFavorites(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    favorites.removeWhere((item) {
      final movie = json.decode(item);
      return movie['id'].toString() == movieId.toString();
    });

    await prefs.setStringList('favorites', favorites);
    loadFavorites();
  }

  // Function to handle pull-to-refresh action
  Future<void> _onRefresh() async {
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color.fromARGB(255, 245, 71, 32),
        child: favoriteMovies.isEmpty
            ? Center(
                child: Text(
                  "No favorites added",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 240,
                  ),
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetails(
                              movieId: movie['id'],
                              type: "movie",
                            ),
                          ),
                        );
                      },
                      child: MovieCard(
                        movieId: movie['id'],
                        imageUrl:
                            'https://image.tmdb.org/t/p/original${movie['image']}',
                        movieTitle: movie['title'],
                        type: movie['type'],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
