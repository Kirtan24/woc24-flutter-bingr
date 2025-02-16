import 'package:bingr/fetures/details/cast.dart';
import 'dart:convert';
import 'package:bingr/screens/home/widgets/genres_list.dart';
import 'package:bingr/services/api_service.dart';
import 'package:bingr/util/helpers/helper_function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetails extends StatefulWidget {
  final int movieId;
  final String type;
  const MovieDetails({super.key, required this.movieId, required this.type});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool isFavorited = false;
  Map<String, dynamic>? movieData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovieData();
    checkIfFavorited();
    // clearFavorites();
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    // Remove the 'favorites' key from SharedPreferences
    await prefs.remove('favorites');

    print("Favorites cleared.");
  }

  Future<void> fetchMovieData() async {
    try {
      final data =
          await MovieService().fetchMovieDetails(widget.movieId, widget.type);
      setState(() {
        movieData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching movie details: $e");
    }
  }

  Future<void> checkIfFavorited() async {
    final prefs = await SharedPreferences.getInstance();

    // Ensure favorites key exists
    if (!prefs.containsKey('favorites')) {
      await prefs.setStringList('favorites', []);
    }

    List<String> favorites = prefs.getStringList('favorites') ?? [];

    List<Map<String, dynamic>> favoriteMovies = favorites
        .map((fav) {
          if (fav.isNotEmpty) {
            try {
              return json.decode(fav) as Map<String, dynamic>?;
            } catch (e) {
              print("Error decoding favorite: $e");
              return null;
            }
          } else {
            return null;
          }
        })
        .where((movie) => movie != null && movie['id'] != null)
        .cast<Map<String, dynamic>>()
        .toList();

    setState(() {
      isFavorited =
          favoriteMovies.any((movie) => movie['id'] == widget.movieId);
    });
  }

  Future<void> addToFavorites(Map<String, dynamic> movieDetails) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    List<Map<String, dynamic>> favoriteMovies = favorites
        .map((fav) {
          if (fav.isNotEmpty) {
            try {
              return json.decode(fav) as Map<String, dynamic>?;
            } catch (e) {
              print("Error decoding favorite: $e");
              return null;
            }
          } else {
            return null;
          }
        })
        .where((movie) => movie != null && movie['id'] != null)
        .cast<Map<String, dynamic>>()
        .toList();

    bool isAlreadyFavorite =
        favoriteMovies.any((movie) => movie['id'] == movieDetails['id']);

    if (!isAlreadyFavorite) {
      favoriteMovies.add({
        'id': movieDetails['id'],
        'title': movieDetails['title'],
        'image': movieDetails['poster_path'],
        'type': widget.type,
      });

      await prefs.setStringList('favorites',
          favoriteMovies.map((movie) => json.encode(movie)).toList());

      BHelperFunction.showToast(
        context: context,
        message: "Added to favorites",
        type: ToastificationType.success,
      );

      setState(() {
        isFavorited = true;
      });
    } else {
      BHelperFunction.showToast(
        context: context,
        message: "Already in favorites",
        type: ToastificationType.warning,
      );
    }
  }

  Future<void> removeFromFavorites(Map<String, dynamic> movieDetails) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    List<Map<String, dynamic>> favoriteMovies = favorites
        .map((fav) {
          if (fav.isNotEmpty && fav.isNotEmpty) {
            try {
              return json.decode(fav) as Map<String, dynamic>?;
            } catch (e) {
              print("Error decoding favorite: $e");
              return null;
            }
          } else {
            return null;
          }
        })
        .where((movie) => movie != null && movie['id'] != null)
        .cast<Map<String, dynamic>>()
        .toList();

    favoriteMovies.removeWhere((movie) => movie['id'] == movieDetails['id']);

    await prefs.setStringList('favorites',
        favoriteMovies.map((movie) => json.encode(movie)).toList());

    setState(() {
      isFavorited = false;
    });
  }

  void addToFavorit(Map<String, dynamic> movieDetails) {
    addToFavorites(movieDetails);
  }

  void removeFromFavorit(Map<String, dynamic> movieDetails) {
    removeFromFavorites(movieDetails);
  }

  void showTrailer(String url) {
    if (url.isEmpty) {
      BHelperFunction.showToast(
        context: context,
        message: "Trailer not available",
        type: ToastificationType.warning,
      );
      return;
    }

    final videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId == null) {
      BHelperFunction.showToast(
        context: context,
        message: "Invalid trailer link",
        type: ToastificationType.error,
      );
      return;
    }

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
      ),
    );

    showDialog(
      context: context,
      builder: (context) {
        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onEnded: (YoutubeMetaData metaData) {
              Navigator.pop(context);
            },
          ),
          builder: (context, player) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: AspectRatio(
                aspectRatio: 16 / 9,
                child: player,
              ),
            );
          },
        );
      },
    ).then((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    });

    // Allow auto rotation when playing video
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 245, 71, 32),
        ),
      );
    }

    if (movieData == null) {
      return const Center(child: Text("Error loading movie details"));
    }

    final boxOffice = movieData?["ratings"]?.containsKey('BoxOffice') ?? false
        ? movieData!["ratings"]['BoxOffice']
        : "N/A";

    final runtime = movieData?["ratings"]?.containsKey('Runtime') ?? false
        ? movieData!["ratings"]['Runtime']
        : "N/A";

    final released = movieData?["ratings"]?.containsKey('Released') ?? false
        ? movieData!["ratings"]['Released']
        : "N/A";

    final ratings = movieData?["ratings"]?.containsKey('Ratings') ?? false
        ? movieData!["ratings"]['Ratings']
        : {};

    final movieDetails = movieData!["movieDetails"] ?? {};
    final credits = movieData!["credits"] ?? {};
    final recommendations = movieData!["recommendations"]?["results"] ?? [];
    final trailerUrl = movieData!["trailerUrl"] ?? "";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(movieDetails["title"] ?? "Movie Details"),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/original${movieDetails['backdrop_path']}',
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, color: Colors.red),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieDetails.containsKey('title')
                        ? movieDetails['title']
                        : movieDetails['name'],
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 30,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        movieDetails['vote_average'].toString(),
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("(Runtime: $runtime)",
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      "Genres : ${movieDetails['genres'].map((genre) => genre['name']).join(', ')}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Plot: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: BHelperFunction.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: movieDetails['overview'],
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: BHelperFunction.isDarkMode(context)
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Release Date : $released",
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  if (ratings.isNotEmpty)
                    Container(
                      color: Colors.transparent,
                      height: 40,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: ratings.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final rating = ratings[index];
                          if (rating is Map<String, dynamic> &&
                              rating.containsKey("Source") &&
                              rating.containsKey("Value")) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                "${rating['Source']} : ${rating['Value']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    )
                  else
                    SizedBox.shrink(),
                  SizedBox(
                    height: 10,
                  ),

                  // Cast
                  if (credits['cast'].isNotEmpty)
                    Cast(
                      castList: credits['cast'],
                    ),

                  // Recommendations
                  if (recommendations.isNotEmpty)
                    GenresList(
                      title: 'Recommendations',
                      recommendations: recommendations,
                      onShowMorePressed: () {},
                    ),

                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    child: Text(
                      "BoxOffice Collection : $boxOffice",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  SizedBox(height: 140),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "fav_btn",
            onPressed: () {
              isFavorited
                  ? removeFromFavorit(movieDetails!)
                  : addToFavorit(movieDetails!);
              // Check if the movie is favorited after the action
              checkIfFavorited();
            },
            backgroundColor: const Color.fromARGB(255, 245, 71, 32),
            child: Icon(
              isFavorited ? Icons.bookmark : Icons.bookmark_add_outlined,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "trailer_btn",
            onPressed: () => showTrailer(trailerUrl),
            backgroundColor: const Color.fromARGB(255, 245, 71, 32),
            icon: Icon(
              Iconsax.play,
              color: Colors.black,
            ),
            label: Text(
              "Watch Trailer",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
