import 'package:bingr/common/widgets/text_field_widget.dart';
import 'package:bingr/screens/details/movie_details.dart';
import 'package:bingr/common/widgets/movie_card.dart';
import 'package:bingr/screens/search/widgets/genre_card.dart';
import 'package:bingr/screens/search/widgets/genre_movie_page.dart';
import 'package:bingr/services/api_service.dart';
import 'package:bingr/util/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Search extends StatefulWidget {
  final FocusNode focusNode;
  const Search({super.key, required this.focusNode});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final MovieService _movieService = MovieService();
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isSearching = false;

  final SpeechToText _stt = SpeechToText();
  String query = "";
  bool isListening = false;

  final List<Map<String, dynamic>> genres = [
    {"id": 28, "name": "Action"},
    {"id": 12, "name": "Adventure"},
    {"id": 16, "name": "Animation"},
    {"id": 35, "name": "Comedy"},
    {"id": 80, "name": "Crime"},
    {"id": 99, "name": "Documentary"},
    {"id": 18, "name": "Drama"},
    {"id": 10751, "name": "Family"},
    {"id": 14, "name": "Fantasy"},
    {"id": 36, "name": "History"},
    {"id": 27, "name": "Horror"},
    {"id": 10402, "name": "Music"},
    {"id": 9648, "name": "Mystery"},
    {"id": 10749, "name": "Romance"},
    {"id": 878, "name": "Science Fiction"},
    {"id": 10770, "name": "TV Movie"},
    {"id": 53, "name": "Thriller"},
    {"id": 10752, "name": "War"},
    {"id": 37, "name": "Western"}
  ];

  final List<Color> _allColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.lime,
    Colors.teal,
    Colors.deepOrange,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.lightGreen,
    Colors.blueGrey,
    Colors.white,
    Colors.grey,
    Colors.lightBlue,
    Colors.deepPurple,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (!widget.focusNode.hasFocus) {
      // Perform any actions needed when the search bar loses focus
    }
  }

  void _searchMovies(String query) async {
    if (query.length < 3) return; // Avoid unnecessary API calls

    setState(() {
      isLoading = true;
      isSearching = true;
    });

    List<dynamic> results = await _movieService.searchMovies(query);

    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  void initSpeechState() async {
    try {
      bool available = await _stt.initialize();
      if (available) {
        setState(() {});
      } else {
        print('Error: Speech-to-text not available.');
      }
    } catch (e) {
      print('Exception during speech initialization: $e');
    }
  }

  void _startListening() async {
    try {
      initSpeechState();
      await _stt.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            setState(() {
              query = result.recognizedWords;
              searchController.text = query;
            });
            _searchMovies(result.recognizedWords);
          }
        },
      );
      setState(() {
        isListening = true;
      });
    } catch (e) {
      print('Exception while starting listening: $e');
    }
  }

  void _stopListening() {
    try {
      _stt.stop();
      setState(() {
        isListening = false;
      });
    } catch (e) {
      print('Exception while stopping listening: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            children: [
              TextFieldWidget(
                focusNode: widget.focusNode,
                textEditingController: searchController,
                prefixIcon: const Icon(Iconsax.search_normal),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, size: 30),
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            searchResults.clear();
                            isListening = false;
                            isSearching = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          isListening
                              ? Iconsax.microphone5
                              : Iconsax.voice_cricle,
                          size: 30,
                          color: isListening
                              ? Colors.red
                              : BHelperFunction.isDarkMode(context)
                                  ? Colors.white
                                  : Colors.black,
                        ),
                        onPressed: () {
                          if (isListening) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        },
                      ),
                hintText: "Search",
                onChanged: _searchMovies,
                onTap: () {
                  setState(() {
                    isSearching = true;
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 245, 71, 32),
                        ),
                      )
                    : isSearching
                        ? searchResults.isEmpty
                            ? const Center(
                                child: Text("No results found"),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  mainAxisExtent: 240,
                                ),
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final movie = searchResults[index];
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
                                      type: movie['media_type'],
                                    ),
                                  );
                                },
                              )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 240,
                              mainAxisExtent: 120,
                            ),
                            itemCount: genres.length,
                            itemBuilder: (context, index) {
                              final genre = genres[index];
                              return GenreCard(
                                genreName: genre['name'],
                                color: _allColors[index % _allColors.length],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GenreMoviesPage(
                                        genreId: genre['id'],
                                        genreName: genre['name'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
