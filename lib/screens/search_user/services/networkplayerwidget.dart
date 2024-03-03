import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class NetworkPlayerWidget extends StatefulWidget {
  final url;
  const NetworkPlayerWidget({super.key,required this.url});

  @override
  State<NetworkPlayerWidget> createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {
  VideoPlayerController ?controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = VideoPlayerController.network(widget.url)..addListener(()=>setState(() {}))..setLooping(true)..initialize().then((value) => null);

  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
