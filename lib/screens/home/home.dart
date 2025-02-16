import 'package:bingr/controllers/tmdb_controller.dart';
// import 'package:bingr/drawer.dart';
import 'package:bingr/screens/home/widgets/carousel.dart';
// import 'package:bingr/screens/home/widgets/genres_list.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final PageController _pageController;
  List<dynamic>? _trendingData; // To store trending movies/series data
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
    _fetchTrendingData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<dynamic>? _cachedTrendingData;

  Future<void> _fetchTrendingData() async {
    try {
      if (_cachedTrendingData != null) {
        setState(() {
          _trendingData = _cachedTrendingData!;
          _isLoading = false;
        });
        return;
      }

      final data = await TMDBController().getTrendingMoviesAndSeries();
      _cachedTrendingData = data.take(10).toList();

      setState(() {
        _trendingData = _cachedTrendingData!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _errorMessage != null
                ? Center(child: Text("Error: $_errorMessage"))
                : _trendingData != null && _trendingData!.isNotEmpty
                    ? CustomCarousel(items: _trendingData!)
                    : SizedBox(
                        height: 400,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: const Color.fromARGB(255, 245, 71, 32),
                        )),
                      ),

            const SizedBox(height: 16),

            // Category-wise cards
            // GenresList(
            //   title: 'Category 1',
            //   itemCount: 10,
            //   onShowMorePressed: () {
            //     print("Show More for Category 1");
            //   },
            // ),
            // GenresList(
            //   title: 'Category 2',
            //   itemCount: 10,
            //   onShowMorePressed: () {
            //     print("Show More for Category 2");
            //   },
            // ),
            // GenresList(
            //   title: 'Category 3',
            //   itemCount: 10,
            //   onShowMorePressed: () {
            //     print("Show More for Category 3");
            //   },
            // ),

            const SizedBox(height: 10),
          ],
        ),
      ),
      extendBody: true,
    );
  }
}
