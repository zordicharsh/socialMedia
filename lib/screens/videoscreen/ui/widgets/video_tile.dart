import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class VideoTile extends StatefulWidget {
  const VideoTile({super.key, required this.video, required this.snappedPageIndex, required this.currentIndex});
final String video;
final int snappedPageIndex;
final int currentIndex;

  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late VideoPlayerController _videoPlayerController;
  late Future _initializeVideoPlayer;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.video));
    _initializeVideoPlayer  = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);


    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    (widget.snappedPageIndex == widget.currentIndex)?_videoPlayerController.play():_videoPlayerController.pause();
    return Container(
      child: FutureBuilder(builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return VideoPlayer(_videoPlayerController);
        }else{
          return Container(
            alignment: Alignment.center,
            child: Lottie.asset('assets/images/tiktok.json',
            fit: BoxFit.cover,
              height: 100,
              width: 100
            ),

          );
        }

      }, future: _initializeVideoPlayer,),
    );
  }
}
