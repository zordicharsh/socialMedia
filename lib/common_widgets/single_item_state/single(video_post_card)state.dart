import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:readmore/readmore.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/profile/ui/widgets/comment.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';
import '../../../common_widgets/like_animation_widget/like_animation_widget.dart';
import '../transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../screens/chat_screen/chat_user_lists/chatlist.dart';
import '../../screens/chat_screen/sharelist.dart';
import '../../screens/navigation_handler/bloc/navigation_bloc.dart';
import '../../screens/profile/bloc/heart_animation_bloc/heart_bloc.dart';
import '../../screens/search_user/ui/searched_profile/anotherprofile.dart';

class SingleVideoPostCardItemState extends StatefulWidget {
  SingleVideoPostCardItemState(
      {super.key,
      required this.postdata,
      required this.isLiked,
      this.value = ""});

  final Map<String, dynamic> postdata;
  bool isLiked;
  final String value;

  @override
  State<SingleVideoPostCardItemState> createState() =>
      _SingleVideoPostCardItemStateState();
}

class _SingleVideoPostCardItemStateState
    extends State<SingleVideoPostCardItemState> {
  bool isHeartAnimating = false;
  final comment = TextEditingController();
  bool emojiShowing = true;
  bool isCommentShareButtonVisible = false;
  bool isVideoPlaying = false;
  CachedVideoPlayerController? videoPlayerController;
  bool isMute = false;
  double previousVideoVolume = 0.0;
  late Stream<DocumentSnapshot> _currentUserDataStream;
  String value = "post";
  bool swipedToChatList = true;

  @override
  void initState() {
    _currentUserDataStream = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    videoPlayerController = CachedVideoPlayerController.network(
        widget.postdata['posturl'].toString(),
        videoPlayerOptions: VideoPlayerOptions())
      ..initialize()
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
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    CustomPageRouteRightToLeft(
                      child: AnotherUserProfile(
                          uid: widget.postdata['uid'],
                          username: widget.postdata['username']),
                    ),
                  ),
                  child: Row(
                    children: [
                      widget.postdata['profileurl'] != ""
                          ? CachedNetworkImage(
                              imageUrl: widget.postdata['profileurl'],
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
                              placeholder: (context, url) => CircleAvatar(
                                radius: 14.1.sp,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[900],
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
                        widget.postdata['username'],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
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
                                          onTap: () => widget.postdata['uid'] ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
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
                                                  if (widget.postdata['uid'] ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid) {
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
                                                                  widget.postdata[
                                                                      'postid'],
                                                                ));
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(
                                                                        backgroundColor: Colors.grey[
                                                                            900],
                                                                        duration: const Duration(
                                                                            milliseconds:
                                                                                1000),
                                                                        elevation:
                                                                            8,
                                                                        behavior:
                                                                            SnackBarBehavior
                                                                                .floating,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.circular(
                                                                                20)),
                                                                        margin: EdgeInsets
                                                                            .only(
                                                                          bottom:
                                                                              MediaQuery.of(context).size.height - 192,
                                                                          right:
                                                                              12,
                                                                          left:
                                                                              12,
                                                                        ),
                                                                        content:
                                                                            const Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.all(4.0),
                                                                              child: Text(
                                                                                "Deleted! ",
                                                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.all(4.0),
                                                                              child: Text(
                                                                                "Your reel has been deleted.",
                                                                                style: TextStyle(fontSize: 14, color: Colors.white54),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        )));
                                                              },
                                                              child: const Text(
                                                                  "Yes")),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
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
                                                                        1500),
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
                                                                  212,
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
                                                                    "Reported! ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
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
                                                                    "Thank you, we will review your report and take appropriate action within 24 hours.",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
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
                                                    widget.postdata['uid'] ==
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
                                                    widget.postdata['uid'] ==
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
            height: MediaQuery.sizeOf(context).height * 0.64,
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
              child: BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, state) {
                  if (state.tabindex == 0) {
                    return GestureDetector(
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
                        log(widget.postdata['postid']);
                        setState(() {
                          log("starting like animation");
                          isHeartAnimating = true;
                          widget.isLiked = true;
                        });
                        BlocProvider.of<HeartBloc>(context).add(
                            ProfilePagePostCardDoubleTapLikedAnimOnPostEvent(
                                widget.postdata['postid']));
                      },
                      onPanUpdate: widget.value == 'post'
                          ? (details) async {
                              if (details.delta.dx < 0) {
                                log("left swiped");
                                if (swipedToChatList && value == 'post') {
                                  Navigator.push(
                                      context,
                                      CustomPageRouteRightToLeft(
                                        child: const ChatLists(),
                                      ));
                                }
                              }
                            }
                          : (details) {},
                      child: Container(
                        color: Colors.transparent,
                        child:
                            Stack(alignment: Alignment.bottomRight, children: [
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: widget.postdata['type'] == 'image'
                                  ? Image(
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      image: CachedNetworkImageProvider(
                                        widget.postdata['posturl'].toString(),
                                      ))
                                  : !videoPlayerController!.value.isInitialized
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              widget.postdata['thumbnail'],
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low,
                                        )
                                      : AspectRatio(
                                          aspectRatio: videoPlayerController!
                                              .value.aspectRatio,
                                          child: CachedVideoPlayer(
                                              videoPlayerController!)),
                            ),
                          ),
                          widget.postdata['type'] != 'image'
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
                          widget.postdata['type'] == 'video'
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
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
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
                    );
                  } else {
                    return GestureDetector(
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
                        log(widget.postdata['postid']);
                        setState(() {
                          log("starting like animation");
                          isHeartAnimating = true;
                          widget.isLiked = true;
                        });
                        BlocProvider.of<HeartBloc>(context).add(
                            ProfilePagePostCardDoubleTapLikedAnimOnPostEvent(
                                widget.postdata['postid']));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Stack(alignment: Alignment.bottomRight, children: [
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: widget.postdata['type'] == 'image'
                                  ? Image(
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.high,
                                      image: CachedNetworkImageProvider(
                                        widget.postdata['posturl'].toString(),
                                      ))
                                  : !videoPlayerController!.value.isInitialized
                                      ? CachedNetworkImage(
                                          imageUrl: widget.postdata['thumbnail'],
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low,
                                        )
                                      : AspectRatio(
                                          aspectRatio: videoPlayerController!
                                              .value.aspectRatio,
                                          child: CachedVideoPlayer(
                                              videoPlayerController!)),
                            ),
                          ),
                          widget.postdata['type'] != 'image'
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
                          widget.postdata['type'] == 'video'
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
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
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
                    );
                  }
                },
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                HeartAnimationWidget(
                  isAnimating: widget.isLiked,
                  alwaysAnimate: true,
                  duration: const Duration(milliseconds: 150),
                  onEnd: () {
                    if (widget.isLiked) {
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
                              widget.postdata['postid']));
                      setState(() {
                        if (!widget.isLiked) {
                          isHeartAnimating = true;
                        }
                        widget.isLiked = !widget.isLiked;
                      });
                    },
                    icon: Icon(
                      size: 28,
                      widget.isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: widget.isLiked ? Colors.red : Colors.white,
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
                                  postId: widget.postdata['postid'],
                                  scrollController: scrollController,
                                  username: widget.postdata['username'],
                                  uidofpostuploader: widget.postdata['uid'],
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
                            Postid: widget.postdata['postid'],
                            Type: widget.postdata['type']),
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.grey[900],
                        duration: const Duration(milliseconds: 800),
                        elevation: 8,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 192,
                          right: 12,
                          left: 12,
                        ),
                        content: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Premium! ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Buy premium to save unlimited posts.",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white54),
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
          child: Text("${widget.postdata['totallikes']} likes"),
        ),
        const SizedBox(
          height: 4,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 12, right: 16),
            child: ReadMoreText(
              widget.postdata['caption'],
              delimiter: '...',
              preDataText: widget.postdata['username'],
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
        widget.postdata['totalcomments'] > 2
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
                                    postId: widget.postdata['postid'],
                                    scrollController: scrollController,
                                    username: widget.postdata['username'],
                                    uidofpostuploader: widget.postdata['uid'],
                                  ));
                        },
                      );
                    },
                    child: Text(
                        "View all ${widget.postdata['totalcomments']} comments",
                        style: const TextStyle(color: Colors.white60))),
              )
            : Row(
                children: [
                  StreamBuilder(
                    stream: _currentUserDataStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text("error");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
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
                                      postId: widget.postdata['postid'],
                                      scrollController: scrollController,
                                      username: widget.postdata['username'],
                                      uidofpostuploader: widget.postdata['uid'],
                                    ));
                          },
                        );
                      },
                      decoration: InputDecoration(
                        hintText: widget.postdata['uid'] ==
                                FirebaseAuth.instance.currentUser?.uid
                            ? 'Add a comment...'
                            : 'Add a comment for ${widget.postdata['username']}...',
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
              DateFormat('MMMMd').format(DateTime.now()) == DateFormat('MMMMd').format(widget.postdata['uploadtime'].toDate())
                  || DateFormat('MMMMd').format(DateTime.now().subtract(const Duration(days:1))) == DateFormat('MMMMd').format(widget.postdata['uploadtime'].toDate())
                  || DateFormat('MMMMd').format(DateTime.now().subtract(const Duration(days:2))) == DateFormat('MMMMd').format(widget.postdata['uploadtime'].toDate())
                  || DateFormat('MMMMd').format(DateTime.now().subtract(const Duration(days:3))) == DateFormat('MMMMd').format(widget.postdata['uploadtime'].toDate())
                  || DateFormat('MMMMd').format(DateTime.now().subtract(const Duration(days:4))) == DateFormat('MMMMd').format(widget.postdata['uploadtime'].toDate())
                  || DateFormat('MMMMd').format(DateTime.now().subtract(const Duration(days:5))) == DateFormat('MMMMd').format(widget.postdata['uploadtime'].toDate())
                  || DateFormat('MMMMd').format(DateTime.now().subtract(const Duration(days:6))) == DateFormat('MMMMd').format(widget.postdata['uploadtime'].toDate())
                  ? Jiffy.parse(widget.postdata['uploadtime'].toDate().toString()).fromNow()
                  : DateFormat.d().add_yMMM().format(widget.postdata['uploadtime'].toDate()),
              style: const TextStyle(color: Colors.white60)),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
