import 'package:bingr/common/text_field_widget.dart';
import 'package:bingr/fetures/details/movie_details.dart';
import 'package:bingr/screens/home/widgets/movie_card.dart';
import 'package:bingr/services/api_service.dart';
import 'package:bingr/util/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  // late stt.SpeechToText _speech;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    // _speech = stt.SpeechToText();
  }

  void _searchMovies(String query) async {
    if (query.length < 3) return; // Avoid unnecessary API calls

    setState(() {
      isLoading = true;
    });

    List<dynamic> results = await _movieService.searchMovies(query);

    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  void _startListening() {
    setState(() {
      isListening = true;
    });
  }

  void _stopListening() {
    setState(() {
      isListening = false;
    });
  }

  // void _startListening() async {
  //   bool available = await _speech.initialize(
  //     onStatus: (status) {
  //       print("Speech recognition status: $status");
  //     },
  //     onError: (error) {
  //       print("Speech recognition error: $error");
  //     },
  //   );

  //   if (available) {
  //     setState(() {
  //       isListening = true;
  //     });

  //     _speech.listen(
  //       onResult: (result) {
  //         setState(() {
  //           searchController.text = result.recognizedWords;
  //         });
  //         _searchMovies(result.recognizedWords);
  //       },
  //     );
  //   }
  // }

  // void _stopListening() {
  //   setState(() {
  //     isListening = false;
  //   });
  //   _speech.stop();
  // }

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
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 245, 71, 32),
                        ),
                      )
                    : searchResults.isEmpty
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
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
