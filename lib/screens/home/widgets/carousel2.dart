// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:bingr/fetures/details/movie_details.dart';

// class CustomCarousel extends StatefulWidget {
//   final List<dynamic> items; // List of items fetched from the API

//   const CustomCarousel({Key? key, required this.items}) : super(key: key);

//   @override
//   State<CustomCarousel> createState() => _CustomCarouselState();
// }

// class _CustomCarouselState extends State<CustomCarousel> {
//   late PageController _pageController;
//   late Timer _autoScrollTimer;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _currentIndex);

//     // Auto-scroll setup
//     _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (_pageController.hasClients) {
//         setState(() {
//           _currentIndex = (_currentIndex + 1) % widget.items.length;
//         });
//         _pageController.animateToPage(
//           _currentIndex,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _autoScrollTimer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 400,
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: widget.items.length,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               final isCurrent = _currentIndex == index;
//               final item = widget.items[index];
//               final imageUrl =
//                   "https://image.tmdb.org/t/p/w600${item['poster_path']}";

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => MovieDetails(movieId: item['id']),
//                     ),
//                   );
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   margin: isCurrent
//                       ? const EdgeInsets.symmetric(horizontal: 8, vertical: 0)
//                       : const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       if (isCurrent)
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           blurRadius: 8,
//                           spreadRadius: 2,
//                         ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       // Cached Image
//                       Positioned.fill(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: CachedNetworkImage(
//                             imageUrl: imageUrl,
//                             fit: BoxFit.contain,
//                             placeholder: (context, url) => ShimmerPlaceholder(),
//                             errorWidget: (context, url, error) =>
//                                 const Center(child: Icon(Icons.error)),
//                           ),
//                         ),
//                       ),
//                       // Title
//                       Positioned(
//                         bottom: 20,
//                         left: 20,
//                         child: Text(
//                           item['title'] ?? 'Untitled',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black,
//                                 blurRadius: 6,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 16),
//         // Dots Indicator
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(widget.items.length, (index) {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               height: 8,
//               width: _currentIndex == index ? 16 : 8,
//               decoration: BoxDecoration(
//                 color: _currentIndex == index
//                     ? Colors.redAccent
//                     : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }

// // Placeholder shimmer effect for loading images
// Widget ShimmerPlaceholder() {
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(16),
//       color: Colors.grey.shade300,
//     ),
//     child: const Center(
//       child: CircularProgressIndicator(),
//     ),
//   );
// }

// import 'dart:async';
// import 'package:bingr/fetures/details/movie_details.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class CustomCarousel extends StatefulWidget {
//   final List<dynamic> items;

//   const CustomCarousel({Key? key, required this.items}) : super(key: key);

//   @override
//   State<CustomCarousel> createState() => _CustomCarouselState();
// }

// class _CustomCarouselState extends State<CustomCarousel> {
//   late PageController _pageController;
//   late Timer _autoScrollTimer;
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: _currentIndex);

//     // Auto-scroll setup
//     _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       if (_pageController.hasClients) {
//         setState(() {
//           _currentIndex = (_currentIndex + 1) % widget.items.length;
//         });
//         _pageController.animateToPage(
//           _currentIndex,
//           duration: const Duration(milliseconds: 500),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _autoScrollTimer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 400,
//           child: PageView.builder(
//             controller: _pageController,
//             itemCount: widget.items.length,
//             onPageChanged: (index) {
//               setState(() {
//                 _currentIndex = index;
//               });
//             },
//             itemBuilder: (context, index) {
//               final isCurrent = _currentIndex == index;
//               final item = widget.items[index];
//               final imageUrl =
//                   "https://image.tmdb.org/t/p/original${item['backdrop_path']}";

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           MovieDetails(movieId: widget.items[index]['id']),
//                     ),
//                   );
//                 },
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   margin: isCurrent
//                       ? const EdgeInsets.symmetric(horizontal: 8, vertical: 0)
//                       : const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//                   child: Stack(
//                     children: [
//                       // Cached Image with Shimmer Effect
//                       Positioned.fill(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: CachedNetworkImage(
//                             imageUrl: imageUrl,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => _buildShimmer(),
//                             errorWidget: (context, url, error) => const Center(
//                                 child:
//                                     Icon(Icons.error, color: Colors.redAccent)),
//                           ),
//                         ),
//                       ),
//                       // Movie Title
//                       Positioned(
//                         bottom: 20,
//                         left: 20,
//                         child: Text(
//                           item['title'] ?? 'Untitled',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black,
//                                 blurRadius: 6,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         const SizedBox(height: 16),
//         // Dots Indicator
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(widget.items.length, (index) {
//             return AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: const EdgeInsets.symmetric(horizontal: 4),
//               height: 8,
//               width: _currentIndex == index ? 16 : 8,
//               decoration: BoxDecoration(
//                 color: _currentIndex == index
//                     ? Colors.redAccent
//                     : Colors.grey.shade400,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   // Shimmer Effect Placeholder
//   Widget _buildShimmer() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black,
//         borderRadius: BorderRadius.circular(16),
//       ),
//     );
//   }
// }
