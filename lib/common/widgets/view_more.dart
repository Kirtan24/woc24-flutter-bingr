import 'package:flutter/material.dart';
import 'package:bingr/common/widgets/movie_card.dart';
import 'package:iconsax/iconsax.dart';

class ViewMore extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final String type;

  const ViewMore({
    Key? key,
    required this.title,
    required this.items,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
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
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 220,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final movie = items[index];
          final movieTitle =
              movie.containsKey('title') ? movie['title'] : movie['name'];
          final movieId = movie["id"];
          final posterPath = movie["poster_path"];
          final imageUrl = posterPath != null
              ? "https://image.tmdb.org/t/p/w200$posterPath"
              : "https://placehold.co/300x400";

          return MovieCard(
            movieId: movieId,
            imageUrl: imageUrl,
            movieTitle: movieTitle,
            type: type,
          );
        },
      ),
    );
  }
}
