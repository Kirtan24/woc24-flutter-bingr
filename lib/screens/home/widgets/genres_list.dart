import 'package:bingr/screens/home/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class GenresList extends StatelessWidget {
  final String title;
  final List<dynamic> recommendations;
  final Function onShowMorePressed;

  const GenresList({
    Key? key,
    required this.title,
    required this.recommendations,
    required this.onShowMorePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onShowMorePressed();
                    },
                    child: Text(
                      'Show More',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 245, 71, 32),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                recommendations.length > 10 ? 10 : recommendations.length,
            itemBuilder: (context, index) {
              final recommendation = recommendations[index];
              final movieTitle = recommendation.containsKey('title')
                  ? recommendation['title']
                  : recommendation['name'];
              final movieId = recommendation["id"];
              final posterPath = recommendation["poster_path"];
              final imageUrl = posterPath != null
                  ? "https://image.tmdb.org/t/p/w200$posterPath"
                  : "https://placehold.co/300x400";
              final type = recommendation['media_type'];

              return MovieCard(
                movieId: movieId,
                imageUrl: imageUrl,
                movieTitle: movieTitle,
                type: type,
              );
            },
          ),
        ),
      ],
    );
  }
}
