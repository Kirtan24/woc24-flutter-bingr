// ignore_for_file: unused_field

import 'package:bingr/controllers/tmdb_controller.dart';
import 'package:bingr/screens/home/widgets/carousel.dart';
import 'package:bingr/common/widgets/genres_list.dart';
import 'package:bingr/common/widgets/view_more.dart';
import 'package:bingr/services/api_service.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MovieService _movieService = MovieService();
  late final PageController _pageController;

  List<dynamic>? _trendingData;
  List<dynamic>? _topRatedMovies;
  List<dynamic>? _topRatedTV;
  List<dynamic>? _upcomingMovies;
  List<dynamic>? _nowPlayingMovies;
  List<dynamic>? _favoritesMovies;

  bool _isTrendingLoading = true;
  bool _isTopMoviesLoading = true;
  bool _isTopTVLoading = true;
  bool _isUpcomingLoading = true;
  bool _isNowPlayingLoading = true;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.7);
    _fetchTrendingData();
    _fetchTopMovies();
    _fetchTopTV();
    _fetchUpcomingMovies();
    _fetchNowPlayingMovies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Fetch Trending Data with Caching
  List<dynamic>? _cachedTrendingData;
  Future<void> _fetchTrendingData() async {
    try {
      if (_cachedTrendingData != null) {
        setState(() {
          _trendingData = _cachedTrendingData!;
          _isTrendingLoading = false;
        });
        return;
      }

      final data = await TMDBController().getTrendingMoviesAndSeries();
      _cachedTrendingData = data.take(10).toList();

      setState(() {
        _trendingData = _cachedTrendingData!;
        _isTrendingLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isTrendingLoading = false;
      });
    }
  }

  /// Fetch Top Rated Movies with Caching
  List<dynamic>? _cachedTopMovies;
  Future<void> _fetchTopMovies() async {
    try {
      if (_cachedTopMovies != null) {
        setState(() {
          _topRatedMovies = _cachedTopMovies!;
          _isTopMoviesLoading = false;
        });
        return;
      }

      final data = await _movieService
          .fetchResponse('/movie/top_rated?language=en-US&page=1&region=IN');
      _cachedTopMovies = data;

      setState(() {
        _topRatedMovies = _cachedTopMovies!;
        _isTopMoviesLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isTopMoviesLoading = false;
      });
    }
  }

  /// Fetch Top Rated TV Shows with Caching
  List<dynamic>? _cachedTopTV;
  Future<void> _fetchTopTV() async {
    try {
      if (_cachedTopTV != null) {
        setState(() {
          _topRatedTV = _cachedTopTV!;
          _isTopTVLoading = false;
        });
        return;
      }

      final data = await _movieService
          .fetchResponse('/tv/top_rated?language=en-US&page=1');
      _cachedTopTV = data;

      setState(() {
        _topRatedTV = _cachedTopTV!;
        _isTopTVLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isTopTVLoading = false;
      });
    }
  }

  /// Fetch Upcoming Movies with Caching
  List<dynamic>? _cachedUpcomingMovies;
  Future<void> _fetchUpcomingMovies() async {
    try {
      if (_cachedUpcomingMovies != null) {
        setState(() {
          _upcomingMovies = _cachedUpcomingMovies!;
          _isUpcomingLoading = false;
        });
        return;
      }

      final data = await _movieService
          .fetchResponse('/movie/upcoming?language=en-US&page=1&region=IN');
      _cachedUpcomingMovies = data;

      setState(() {
        _upcomingMovies = _cachedUpcomingMovies!;
        _isUpcomingLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isUpcomingLoading = false;
      });
    }
  }

  /// Fetch Now Playing Movies with Caching
  List<dynamic>? _cachedNowPlaying;
  Future<void> _fetchNowPlayingMovies() async {
    try {
      if (_cachedNowPlaying != null) {
        setState(() {
          _nowPlayingMovies = _cachedNowPlaying!;
          _isNowPlayingLoading = false;
        });
        return;
      }

      final data = await _movieService
          .fetchResponse('/movie/now_playing?language=en-US&page=1&region=IN');
      _cachedNowPlaying = data;

      setState(() {
        _nowPlayingMovies = _cachedNowPlaying!;
        _isNowPlayingLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isNowPlayingLoading = false;
      });
    }
  }

  /// Show Full List Page
  void _showFullList(String title, List<dynamic> items, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewMore(title: title, items: items, type: type),
      ),
    );
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
                : _isTrendingLoading
                    ? SizedBox(
                        height: 400,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: const Color.fromARGB(255, 245, 71, 32),
                        )),
                      )
                    : CustomCarousel(items: _trendingData ?? []),
            const SizedBox(height: 16),
            GenresList(
              title: "Top Rated Movies",
              data: _topRatedMovies ?? [],
              onShowMorePressed: () => _showFullList(
                  "Top Rated Movies", _topRatedMovies ?? [], "movie"),
              type: "movie",
            ),
            GenresList(
              title: "Top Rated TV Shows",
              data: _topRatedTV ?? [],
              onShowMorePressed: () =>
                  _showFullList("Top Rated TV Shows", _topRatedTV ?? [], "tv"),
              type: "tv",
            ),
            GenresList(
              title: "Now Playing",
              data: _nowPlayingMovies ?? [],
              onShowMorePressed: () => _showFullList(
                  "Now Playing", _nowPlayingMovies ?? [], "movie"),
              type: "movie",
            ),
            GenresList(
              title: "Upcoming Movies",
              data: _upcomingMovies ?? [],
              onShowMorePressed: () => _showFullList(
                  "Upcoming Movies", _upcomingMovies ?? [], "movie"),
              type: "movie",
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      extendBody: true,
    );
  }
}
