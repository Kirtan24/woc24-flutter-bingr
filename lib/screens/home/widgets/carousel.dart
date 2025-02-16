import 'package:bingr/fetures/details/movie_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class CustomCarousel extends StatefulWidget {
  final List<dynamic> items;

  const CustomCarousel({Key? key, required this.items}) : super(key: key);

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  CarouselSliderController buttonCarouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        CarouselSlider.builder(
          carouselController: buttonCarouselController,
          itemCount: widget.items.length,
          options: CarouselOptions(
            height: 450,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 2),
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            aspectRatio: 9 / 16,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final item = widget.items[index];
            final posterUrl =
                "https://image.tmdb.org/t/p/original${item['poster_path']}";

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetails(
                      movieId: item['id'],
                      type: item['media_type'],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: posterUrl,
                  fit: BoxFit.cover,
                  width: double.infinity, // Adjust size as needed
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, color: Colors.red),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16),
        Text(
          widget.items[_currentIndex]['media_type'] == 'movie'
              ? widget.items[_currentIndex]['title'] ?? 'Untitled'
              : widget.items[_currentIndex]['name'] ?? 'Untitled',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
