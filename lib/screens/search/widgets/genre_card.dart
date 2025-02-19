import 'package:flutter/material.dart';

class GenreCard extends StatelessWidget {
  final String genreName;
  final Color color;
  final VoidCallback onTap;

  const GenreCard({
    Key? key,
    required this.genreName,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Card(
          color: color,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              genreName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
