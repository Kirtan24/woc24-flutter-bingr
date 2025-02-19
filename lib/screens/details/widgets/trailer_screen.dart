import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerScreen extends StatefulWidget {
  final String youtubeId;

  const TrailerScreen({Key? key, required this.youtubeId}) : super(key: key);

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: true,
        enableCaption: false,
        loop: false,
      ),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _isFullScreen = _controller.value.isFullScreen;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        onReady: () => debugPrint("YouTube Player Ready"),
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          IconButton(
            icon: Icon(Icons.fullscreen),
            onPressed: () {
              _controller.toggleFullScreenMode();
            },
          ),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: _isFullScreen
              ? null // Hide app bar in fullscreen mode
              : AppBar(
                  centerTitle: true,
                  title: Text("Watch Trailer"),
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
          body: Container(
            color: Colors.black,
            child: Center(child: player),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
