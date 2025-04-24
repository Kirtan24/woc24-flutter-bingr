import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bingr/screens/details/movie_details.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.movieId,
    required this.imageUrl,
    required this.movieTitle,
    required this.type,
  });

  final dynamic movieId;
  final String? imageUrl;
  final dynamic movieTitle;
  final String type;

  static const String placeholderUrl = 'https://placehold.co/200x300/png';

  @override
  Widget build(BuildContext context) {
    final String validImageUrl =
        (imageUrl != null && imageUrl!.isNotEmpty) ? imageUrl! : placeholderUrl;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MovieDetails(movieId: movieId, type: type), // Dynamic type
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            width: 120,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: validImageUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 245, 71, 32),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Image.network(
                  placeholderUrl,
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 140,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                movieTitle ?? "Unknown Title",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
