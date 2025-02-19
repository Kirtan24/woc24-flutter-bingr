import 'package:bingr/screens/details/movie_details.dart';
import 'package:flutter/material.dart';
import 'package:bingr/services/api_service.dart';
import 'package:bingr/common/widgets/movie_card.dart';
import 'package:iconsax/iconsax.dart';

class GenreMoviesPage extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreMoviesPage({required this.genreId, required this.genreName});

  @override
  _GenreMoviesPageState createState() => _GenreMoviesPageState();
}

class _GenreMoviesPageState extends State<GenreMoviesPage> {
  final MovieService _movieService = MovieService();
  List<dynamic> genreMovies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGenreMovies();
  }

  void _fetchGenreMovies() async {
    genreMovies = await _movieService.getMoviesByGenre(widget.genreId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.genreName),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: const Color.fromARGB(255, 245, 71, 32),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: IconThemeData(
          color: const Color.fromARGB(255, 245, 71, 32),
          size: 30,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 245, 71, 32),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisExtent: 220,
              ),
              itemCount: genreMovies.length,
              itemBuilder: (context, index) {
                final movie = genreMovies[index];
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
                        'https://image.tmdb.org/t/p/original${movie.containsKey('poster_path') ? movie['poster_path'] : movie['backdrop_path']}',
                    movieTitle: movie.containsKey('title')
                        ? movie['title']
                        : movie['name'],
                    type: "movie",
                  ),
                );
              },
            ),
    );
  }
}
