import 'package:bingr/common/widgets/movie_card.dart';
import 'package:flutter/material.dart';

class GenresList extends StatelessWidget {
  final String title;
  final List<dynamic> data;
  final Function? onShowMorePressed;
  final String? type;

  const GenresList({
    Key? key,
    required this.title,
    required this.data,
    this.onShowMorePressed,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onShowMorePressed != null)
                TextButton(
                  onPressed: () => onShowMorePressed?.call(),
                  child: const Text(
                    'Show More',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 245, 71, 32),
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length > 10 ? 10 : data.length,
            itemBuilder: (context, index) {
              final d = data[index];
              final movieTitle =
                  d.containsKey('title') ? d['title'] : d['name'];
              final movieId = d['id'];
              final posterPath = d['poster_path'];
              final imageUrl = posterPath != null
                  ? 'https://image.tmdb.org/t/p/w200$posterPath'
                  : 'https://placehold.co/300x400';

              return MovieCard(
                movieId: movieId,
                imageUrl: imageUrl,
                movieTitle: movieTitle,
                type: type ?? '',
              );
            },
          ),
        ),
      ],
    );
  }
}
