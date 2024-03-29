import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/profile/ui/widgets/comment.dart';
import 'package:video_player/video_player.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../../../chat_screen/sharelist.dart';
import '../../../../common_widgets/like_animation_widget/like_animation_widget.dart';
import '../../bloc/heart_animation_bloc/heart_bloc.dart';

class SinglePostCardItemState extends StatefulWidget {
  const SinglePostCardItemState(
      {super.key, required this.index, required this.postdata});

  final int index;
  final QuerySnapshot postdata;

  @override
  State<SinglePostCardItemState> createState() =>
      _SinglePostCardItemStateState();
}

class _SinglePostCardItemStateState extends State<SinglePostCardItemState> {
  List randomImages = [
    "https://i.pinimg.com/474x/db/c7/63/dbc7636bb173ffb38acb503d8ee44995.jpg",
    "https://i.pinimg.com/474x/a7/e8/89/a7e889effe08ecbede2ddaafbecdbd66.jpg",
    "https://i.pinimg.com/236x/21/ea/de/21eade75b326b412dbff2aa320f571c8.jpg",
  ];
  bool isHeartAnimating = false;
  late bool isLiked;
  final comment = TextEditingController();
  bool emojiShowing = true;
  bool isCommentShareButtonVisible = false;
  bool isVideoPlaying = false;
  VideoPlayerController? videoPlayerController;
  bool isMute = false;
  double previousVideoVolume = 0.0;
  late Stream<DocumentSnapshot> _currentUserDataStream;

  @override
  void initState() {
    _currentUserDataStream = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    isLiked = widget.postdata.docs[widget.index]['likes']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.postdata.docs[widget.index]['posturl'].toString()),
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize().then((_) => setState(() {}))
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 0.0, bottom: 4, right: 8, left: 12),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    widget.postdata.docs[widget.index]['profileurl'] != ""
                        ? CachedNetworkImage(
                            imageUrl: widget.postdata.docs[widget.index]
                                ['profileurl'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 14.1.sp,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: imageProvider,
                                radius: 14.sp,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 14.1.sp,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.8),
                              radius: 14.sp,
                              child: Icon(Icons.person,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      widget.postdata.docs[widget.index]['username'],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey[900],
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: const Icon(
                                              CupertinoIcons.xmark_circle,
                                              size: 32,
                                              color: Colors.grey,
                                            )),
                                        GestureDetector(
                                          onTap: () =>
                                              widget.postdata.docs[widget.index]
                                                          ['uid'] ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? null
                                                  : Navigator.pop(context),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0),
                                            child: MaterialButton(
                                                color: Colors.grey[900],
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                highlightColor:
                                                    Colors.transparent,
                                                splashColor: Colors.transparent,
                                                elevation: 0,
                                                focusElevation: 0,
                                                highlightElevation: 0,
                                                onPressed: () {
                                                  if (widget.postdata.docs[widget.index]['uid'] == FirebaseAuth.instance.currentUser!.uid) {
                                                    showCupertinoDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          CupertinoAlertDialog(
                                                        title: const Text(
                                                          "Alert !",
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        content: const Text(
                                                          "Are you sure you want to delete this post?",
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                        actions: <CupertinoDialogAction>[
                                                          CupertinoDialogAction(
                                                              isDestructiveAction:
                                                                  false,
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                "No",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white60),
                                                              )),
                                                          CupertinoDialogAction(
                                                              isDestructiveAction:
                                                                  true,
                                                              onPressed: () {
                                                                BlocProvider.of<
                                                                            ProfileBloc>(
                                                                        context)
                                                                    .add(
                                                                        DeletePostEvent(
                                                                  widget.postdata
                                                                              .docs[
                                                                          widget
                                                                              .index]
                                                                      [
                                                                      'postid'],
                                                                ));
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  "Yes")),
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  else {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[900],
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        800),
                                                            elevation: 8,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            margin:
                                                                EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height -
                                                                  140,
                                                              right: 12,
                                                              left: 12,
                                                            ),
                                                            content:
                                                                const Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4.0),
                                                                  child: Text(
                                                                    "Oops! ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              4.0),
                                                                  child: Text(
                                                                    "Currently this feature is under development.",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .white54),
                                                                  ),
                                                                )
                                                              ],
                                                            )));
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    widget.postdata.docs[widget
                                                                    .index]
                                                                ['uid'] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? const Icon(
                                                            CupertinoIcons
                                                                .delete,
                                                            color: Colors.red,
                                                            size: 20,
                                                          )
                                                        : const Icon(
                                                            CupertinoIcons
                                                                .exclamationmark_triangle,
                                                            color: Colors.red,
                                                            size: 20,
                                                          ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    widget.postdata.docs[widget
                                                                    .index]
                                                                ['uid'] ==
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid
                                                        ? const Text(
                                                            "Delete Post",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          )
                                                        : const Text(
                                                            "Report",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            backgroundColor: Colors.transparent);
                      },
                      icon: const Icon(Icons.more_vert_sharp),
                      color: Colors.white,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
            height: widget.postdata.docs[widget.index]['type'] == 'image'
                ? MediaQuery.sizeOf(context).height * 0.45
                : MediaQuery.sizeOf(context).height * 0.64,
            width: double.infinity,
            child: ZoomOverlay(
              modalBarrierColor: Colors.black12,
              minScale: 0.5,
              maxScale: 3.0,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: const Duration(milliseconds: 300),
              twoTouchOnly: true,
              onScaleStart: () {},
              onScaleStop: () {},
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isVideoPlaying = !isVideoPlaying;
                    isVideoPlaying == false
                        ? videoPlayerController!.pause()
                        : videoPlayerController!.play();
                  });
                  log(isVideoPlaying.toString());
                },
                onDoubleTap: () {
                  log(widget.postdata.docs[widget.index]['postid']);
                  setState(() {
                    log("starting like animation");
                    isHeartAnimating = true;
                    isLiked = true;
                  });
                  BlocProvider.of<HeartBloc>(context).add(
                      ProfilePagePostCardDoubleTapLikedAnimOnPostEvent(
                          widget.postdata.docs[widget.index]['postid']));
                },
                child: Stack(alignment: Alignment.bottomRight, children: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: widget.postdata.docs[widget.index]['type'] ==
                              'image'
                          ? Image(
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                              image: CachedNetworkImageProvider(
                                widget.postdata.docs[widget.index]['posturl']
                                    .toString(),
                              ))
                          : !videoPlayerController!.value.isInitialized
                              ? CachedNetworkImage(
                                  imageUrl: widget.postdata.docs[widget.index]
                                      ['thumbnail'],
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                )
                              : AspectRatio(
                                  aspectRatio:
                                      videoPlayerController!.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController!)),
                    ),
                  ),
                  widget.postdata.docs[widget.index]['type'] != 'image'
                      ? isVideoPlaying == true
                          ? Positioned(
                              top: 16.sp,
                              left: 320.sp,
                              child: const Icon(
                                CupertinoIcons.pause_solid,
                                color: Colors.white70,
                              ))
                          : Positioned(
                              top: 16.sp,
                              left: 320.sp,
                              child: const Icon(
                                CupertinoIcons.play_arrow_solid,
                                color: Colors.white70,
                              ))
                      : const SizedBox.shrink(),
                  Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isHeartAnimating ? 1 : 0,
                      child: HeartAnimationWidget(
                        duration: const Duration(milliseconds: 200),
                        onEnd: () => setState(() {
                          log("making  isHeartAnimating = false from on end");
                          isHeartAnimating = false;
                        }),
                        isAnimating: isHeartAnimating,
                        child: Icon(
                          CupertinoIcons.heart_fill,
                          color: Colors.white,
                          size: 100,
                          semanticLabel: 'You Liked A Post',
                          shadows: [
                            BoxShadow(
                                blurRadius: 50,
                                spreadRadius: 20,
                                color: Colors.black.withOpacity(0.4),
                                blurStyle: BlurStyle.normal,
                                offset: const Offset(3, 3))
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.postdata.docs[widget.index]['type'] == 'video'
                      ? Padding(
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
                        )
                      : const SizedBox.shrink(),
                ]),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                HeartAnimationWidget(
                  isAnimating: isLiked,
                  alwaysAnimate: true,
                  duration: const Duration(milliseconds: 150),
                  onEnd: () {
                    if (isLiked) {
                      setState(() {
                        isHeartAnimating = false;
                      });
                    }
                  },
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      BlocProvider.of<HeartBloc>(context).add(
                          ProfilePagePostCardOnPressedLikedAnimOnPostEvent(
                              widget.postdata.docs[widget.index]['postid']));
                      setState(() {
                        if (!isLiked) {
                          isHeartAnimating = true;
                        }
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      size: 28,
                      isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: isLiked ? Colors.red : Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  highlightColor: Colors.black.withOpacity(0),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return DraggableScrollableSheet(
                            snap: true,
                            snapSizes: const [0.71, 0.72],
                            maxChildSize: 0.96,
                            initialChildSize: 0.96,
                            minChildSize: 0.4,
                            builder: (context, scrollController) =>
                                CommentSection(
                                  postId: widget.postdata.docs[widget.index]
                                      ['postid'],
                                  scrollController: scrollController,
                                  username: widget.postdata.docs[widget.index]
                                      ['username'],
                                  uidofpostuploader:
                                      widget.postdata.docs[widget.index]['uid'],
                                ));
                      },
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.chat_bubble,
                    size: 26,
                  ),
                  color: Colors.white,
                ),
                IconButton(
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => ShareScreen(
                            Postid: widget.postdata.docs[widget.index]
                                ['postid'],
                            Type: widget.postdata.docs[widget.index]['type']),
                        constraints: const BoxConstraints(maxHeight: 400));
                  },
                  icon: const Icon(
                    CupertinoIcons.paperplane,
                    size: 24,
                  ),
                  color: Colors.white,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    ScaffoldMessenger.of(
                        context)
                        .showSnackBar(SnackBar(
                        backgroundColor:
                        Colors
                            .grey[900],
                        duration:
                        const Duration(
                            milliseconds:
                            800),
                        elevation: 8,
                        behavior:
                        SnackBarBehavior
                            .floating,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                                20)),
                        margin:
                        EdgeInsets.only(
                          bottom: MediaQuery.of(
                              context)
                              .size
                              .height -
                              160,
                          right: 12,
                          left: 12,
                        ),
                        content:
                        const Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets
                                  .all(
                                  4.0),
                              child: Text(
                                "Oops! ",
                                style: TextStyle(
                                    fontSize:
                                    20,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                    color: Colors
                                        .white),
                              ),
                            ),
                            Padding(
                              padding:
                              EdgeInsets
                                  .all(
                                  4.0),
                              child: Text(
                                "Currently bookmarking a post feature is under development.",
                                style: TextStyle(
                                    fontSize:
                                    16,
                                    color: Colors
                                        .white54),
                              ),
                            )
                          ],
                        )));
                  },
                  icon: const Icon(
                    CupertinoIcons.bookmark,
                    size: 24,
                  ),
                  color: Colors.white,
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
          child:
              Text("${widget.postdata.docs[widget.index]['totallikes']} likes"),
        ),
        const SizedBox(
          height: 4,
        ),
        /*Padding(
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 4, left: 16, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    for (int i = 0; i < randomImages.length; i++)
                      Align(
                        widthFactor: 0.59,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black,
                          child: CachedNetworkImage(
                            filterQuality: FilterQuality.low,
                            placeholder: (context, url) => CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey.withOpacity(0.4),
                              ),
                            ),
                            imageUrl: randomImages[i],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 10,
                              backgroundImage: imageProvider,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
           Row(
                  children: [
                    RichText(
                        text: const TextSpan(
                            style: TextStyle(color: Colors.white),
                            children: [
                          TextSpan(
                            text: "   Liked by",
                          ),
                          TextSpan(
                            text: " naman2811",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " and",
                          ),
                          TextSpan(
                            text: " 36 others",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]))
                    //   Text("Liked by naman2811 and 36 others")
                  ],
                )
              ],
            ),
          ),*/
        Padding(
            padding: const EdgeInsets.only(left: 12, right: 16),
            child: ReadMoreText(
              widget.postdata.docs[widget.index]['caption'],
              delimiter: '...',
              preDataText: widget.postdata.docs[widget.index]['username'],
              preDataTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              trimCollapsedText: 'View More',
              trimExpandedText: '  View Less',
              trimMode: TrimMode.Length,
              trimLength: 64,
              moreStyle: TextStyle(
                fontSize: 10.sp,
                color: Colors.white60,
              ),
              lessStyle: TextStyle(
                fontSize: 10.sp,
                color: Colors.white60,
              ),
            )),
        widget.postdata.docs[widget.index]['totalcomments'] > 2
            ? Padding(
                padding: const EdgeInsets.only(
                    top: 4.0, right: 12, left: 12, bottom: 4),
                child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return DraggableScrollableSheet(
                              snap: true,
                              snapSizes: const [0.71, 0.72],
                              maxChildSize: 0.96,
                              initialChildSize: 0.96,
                              minChildSize: 0.4,
                              builder: (context, scrollController) =>
                                  CommentSection(
                                    postId: widget.postdata.docs[widget.index]
                                        ['postid'],
                                    scrollController: scrollController,
                                    username: widget.postdata.docs[widget.index]
                                        ['username'],
                                    uidofpostuploader: widget
                                        .postdata.docs[widget.index]['uid'],
                                  ));
                        },
                      );
                    },
                    child: Text(
                        "View all ${widget.postdata.docs[widget.index]['totalcomments']} comments",
                        style: const TextStyle(color: Colors.white60))),
              )
            : Row(
                children: [
                  StreamBuilder(
                    stream: _currentUserDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: CircleAvatar(
                            radius: 12.1,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.black.withOpacity(0.8),
                              radius: 12,
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text("error");
                      } else {
                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return userData['profileurl'] != ""
                            ? Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: CachedNetworkImage(
                                  imageUrl: userData['profileurl'],
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 12.1,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage: imageProvider,
                                      radius: 12,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: CircleAvatar(
                                  radius: 12.1,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.black.withOpacity(0.8),
                                    radius: 12,
                                    child: Icon(Icons.person,
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                ),
                              );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    height: 40.h,
                    width: 224.w,
                    child: TextField(
                      style: TextStyle(fontSize: 11.sp),
                      // onChanged: (value) => _showCommentShareButton(value),
                      controller: comment,
                      // autofocus: true,
                      readOnly: true,
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return DraggableScrollableSheet(
                                snap: true,
                                snapSizes: const [0.71, 0.72],
                                maxChildSize: 0.96,
                                initialChildSize: 0.96,
                                minChildSize: 0.4,
                                builder: (context, scrollController) =>
                                    CommentSection(
                                      postId: widget.postdata.docs[widget.index]
                                          ['postid'],
                                      scrollController: scrollController,
                                      username: widget.postdata
                                          .docs[widget.index]['username'],
                                      uidofpostuploader: widget
                                          .postdata.docs[widget.index]['uid'],
                                    ));
                          },
                        );
                      },
                      decoration: InputDecoration(
                        hintText: widget.postdata.docs[widget.index]['uid'] ==
                                FirebaseAuth.instance.currentUser?.uid
                            ? 'Add a comment...'
                            : 'Add a comment for ${widget.postdata.docs[widget.index]['username']}...',
                        hintStyle: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
          child: Text(
              DateFormat.d().add_yMMM().format(
                  widget.postdata.docs[widget.index]['uploadtime'].toDate()),
              style: const TextStyle(color: Colors.white60)),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
