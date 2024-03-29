import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../search_user/searchui/searched_profile/anotherprofile.dart';

class VideoTile extends StatefulWidget {
  const VideoTile(
      {super.key,
      required this.video,
      required this.snappedPageIndex,
      required this.currentIndex, required this.filteredList});
  final String video;
  final int snappedPageIndex;
  final int currentIndex;
  final List filteredList;


  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _videoPlayerController;
  late Future _initializeVideoPlayer;
  bool _isVideoPlaying = true;
  bool swipedToChatList = true;

  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.video));
    _initializeVideoPlayer = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    (widget.snappedPageIndex == widget.currentIndex && _isVideoPlaying)
        ? _videoPlayerController.play()
        : _videoPlayerController.pause();
    return GestureDetector(
      onPanUpdate: (details) async {
        if (details.delta.dx < 0) {
          log("left swiped");
          if (swipedToChatList) {
            _videoPlayerController.pause();
            setState(() {
              _isVideoPlaying = false;
            });
            Navigator.push(
                context,
                CustomPageRouteRightToLeft(
                  child:  AnotherUserProfile(uid: widget.filteredList[widget.currentIndex]['uid'], username:widget.filteredList[widget.currentIndex]['username'] ),
                ));
          }
        }
      },
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                _isVideoPlaying
                    ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
                setState(() {
                  _isVideoPlaying = !_isVideoPlaying;
                });
              },
              child: Stack(alignment: Alignment.center, children: [
                Center(child: AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio,child: VideoPlayer(_videoPlayerController))),
                Icon(
                  Icons.play_arrow,
                  color:
                  Colors.white.withOpacity(_isVideoPlaying ? 0 : 0.8),
                  size: 100,
                ),
              ]),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: Lottie.asset('assets/images/tiktok.json',
                  fit: BoxFit.cover, height: 100, width: 100),
            );
          }
        },
        future: _initializeVideoPlayer,
      ),
    );
  }
}
