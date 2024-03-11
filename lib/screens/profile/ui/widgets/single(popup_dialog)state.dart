import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_widgets/like_animation_widget/like_animation_widget.dart';
import '../../bloc/heart_animation_bloc/heart_bloc.dart';

class SinglePopupDialogState extends StatefulWidget {
  SinglePopupDialogState({
    super.key,
    required this.index,
    required this.postdata,
    required this.likeState,
    required this.commentState,
    required this.shareState,
    required this.isLiked,
    required this.isHeartAnimating,
  });

  final int index;
  final QuerySnapshot postdata;
  final GlobalKey<TooltipState> likeState;
  final GlobalKey<TooltipState> commentState;
  final GlobalKey<TooltipState> shareState;
  bool isLiked;
  bool isHeartAnimating;

  @override
  State<SinglePopupDialogState> createState() => _SinglePopupDialogStateState();
}

class _SinglePopupDialogStateState extends State<SinglePopupDialogState> {
  VideoPlayerController? videoPlayerController;
  bool isMute = false;
  double previousVideoVolume = 0.0;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.postdata.docs[widget.index]['posturl'].toString()),
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((_) => setState(() {}))
      ..play()
      ..setLooping(true);
    previousVideoVolume = videoPlayerController!.value.volume;
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _createPopupContent(widget.index, widget.postdata);
  }

  Widget _createPopupContent(int index, QuerySnapshot postdata) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(
                  widget.postdata.docs[widget.index]['profileurl'],
                  widget.postdata.docs[widget.index]['username']),
              widget.postdata.docs[widget.index]['type'] == 'image'
                  ? Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.415,
                      color: Colors.black,
                      child: Stack(alignment: Alignment.center, children: [
                        SizedBox(
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: widget.postdata.docs[widget.index]
                                ['posturl'],
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        BlocBuilder<HeartBloc, HeartState>(
                          buildWhen: (previous, current) {
                            if (current
                                is ProfilePagePopUpDialogPostLikedActionState) {
                              ProfilePagePostCardOnPressedLikedAnimOnPostEvent(
                                  widget.postdata.docs[widget.index]['postid']);
                              setState(() {
                                widget.isLiked = current.isLiked;
                                widget.isHeartAnimating =
                                    current.isHeartAnimating;
                              });
                              return true;
                            } else {
                              return false;
                            }
                          },
                          builder: (context, state) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: widget.isHeartAnimating ? 1 : 0,
                              child: HeartAnimationWidget(
                                duration: const Duration(milliseconds: 200),
                                onEnd: () {
                                  setState(() {
                                    log("making  isHeartAnimating = false from onend");
                                    widget.isHeartAnimating = false;
                                  });
                                },
                                isAnimating: widget.isHeartAnimating,
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                  size: 100,
                                  semanticLabel: 'You Liked A Post',
                                  shadows: [
                                    BoxShadow(
                                        blurRadius: 50,
                                        spreadRadius: 200,
                                        color: Colors.black.withOpacity(0.2),
                                        blurStyle: BlurStyle.normal,
                                        offset: const Offset(1, -3))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ]),
                    )
                  : Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.64,
                      color: Colors.black,
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        Center(
                          child: SizedBox(
                              width: double.infinity,
                              child: !videoPlayerController!.value.isInitialized
                                  ? CachedNetworkImage(
                                      imageUrl: widget.postdata
                                          .docs[widget.index]['thumbnail'],
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.low,
                                    )
                                  : AspectRatio(
                                      aspectRatio: videoPlayerController!
                                          .value.aspectRatio,
                                      child:
                                          VideoPlayer(videoPlayerController!))),
                        ),
                        Center(
                          child: BlocBuilder<HeartBloc, HeartState>(
                            buildWhen: (previous, current) {
                              if (current
                                  is ProfilePagePopUpDialogPostLikedActionState) {
                                setState(() {
                                  widget.isLiked = current.isLiked;
                                  widget.isHeartAnimating =
                                      current.isHeartAnimating;
                                });
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              return AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: widget.isHeartAnimating ? 1 : 0,
                                child: HeartAnimationWidget(
                                  duration: const Duration(milliseconds: 200),
                                  onEnd: () {
                                    setState(() {
                                      log("making  isHeartAnimating = false from onend");
                                      widget.isHeartAnimating = false;
                                    });
                                  },
                                  isAnimating: widget.isHeartAnimating,
                                  child: Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.white,
                                    size: 100,
                                    semanticLabel: 'You Liked A Post',
                                    shadows: [
                                      BoxShadow(
                                          blurRadius: 50,
                                          spreadRadius: 200,
                                          color: Colors.black.withOpacity(0.2),
                                          blurStyle: BlurStyle.normal,
                                          offset: const Offset(1, -3))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () => setState(() {
                              isMute = !isMute;
                              isMute == false
                                  ? videoPlayerController!
                                      .setVolume(previousVideoVolume)
                                  : videoPlayerController!.setVolume(0);
                            }),
                            child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.black.withOpacity(0.8),
                                child: Center(
                                    child: isMute == false
                                        ? const Icon(
                                            Icons.volume_up_sharp,
                                            size: 18,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.volume_off_sharp,
                                            size: 18,
                                            color: Colors.white,
                                          ))),
                          ),
                        ),
                      ]),
                    ),
              _createActionBar(),
            ],
          ),
        ),
      );

  Widget _createPhotoTitle(String profileurl, String username) => Container(
      width: double.infinity,
      color: Colors.grey[900],
      child: ListTile(
        leading: profileurl != ""
            ? CircleAvatar(
                radius: 14.1,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(profileurl),
                  radius: 14,
                ),
              )
            : CircleAvatar(
                radius: 14.1,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.8),
                  radius: 14,
                  child:
                      Icon(Icons.person, color: Colors.black.withOpacity(0.5)),
                ),
              ),
        title: Text(
          username,
          // "hi",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));

  Widget _createActionBar() => Container(
        padding: EdgeInsets.zero,
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Tooltip(
              key: widget.likeState,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(4)),
              textStyle: const TextStyle(color: Colors.white),
              preferBelow: false,
              verticalOffset: 40,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              showDuration: const Duration(seconds: 0),
              enableFeedback: true,
              message: widget.isLiked ? "Unlike" : "Like",
              child: BlocBuilder<HeartBloc, HeartState>(
                builder: (context, state) {
                  return HeartAnimationWidget(
                    isAnimating: widget.isLiked,
                    alwaysAnimate: true,
                    duration: const Duration(milliseconds: 150),
                    onEnd: () {
                      if (widget.isLiked) {
                        setState(() {
                          widget.isHeartAnimating = false;
                        });
                      }
                    },
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        /*   setState(() {
                          if (!isLiked) {
                            isHeartAnimating = true;
                          }
                          isLiked = !isLiked;
                        });*/
                      },
                      icon: Icon(
                        widget.isLiked
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: widget.isLiked ? Colors.red : Colors.white,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            ),
            Tooltip(
              key: widget.commentState,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black.withOpacity(0.8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              textStyle: const TextStyle(
                color: Colors.white,
              ),
              preferBelow: false,
              verticalOffset: 40,
              showDuration: const Duration(seconds: 0),
              enableFeedback: true,
              message: "Comment",
              child: IconButton(
                icon: const Icon(
                  CupertinoIcons.chat_bubble,
                  size: 26,
                ),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Tooltip(
              key: widget.shareState,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4)),
              textStyle: const TextStyle(color: Colors.white),
              preferBelow: false,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              verticalOffset: 40,
              showDuration: const Duration(seconds: 0),
              enableFeedback: true,
              message: "Share",
              child: IconButton(
                icon: const Icon(
                  CupertinoIcons.paperplane,
                  size: 26,
                ),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
}
