import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:socialmedia/screens/videos_screen/ui/widgets/video_details.dart';
import '../../../../common_widgets/like_animation_widget/like_animation_widget.dart';
import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../chat_screen/sharelist.dart';
import '../../../profile/bloc/heart_animation_bloc/heart_bloc.dart';
import '../../../profile/bloc/profile_bloc.dart';
import '../../../profile/ui/widgets/comment.dart';
import '../../../search_user/ui/searched_profile/anotherprofile.dart';



class VideoTile extends StatefulWidget {
   VideoTile(
      {super.key,
      required this.video,
      required this.snappedPageIndex,
      required this.currentIndex, required this.filteredList,required this.isLiked});
  final String video;
  final int snappedPageIndex;
  final int currentIndex;
  final List filteredList;
  bool isLiked;


  @override
  State<VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<VideoTile> {
  late CachedVideoPlayerController _videoPlayerController;
  late Future _initializeVideoPlayer;
  bool _isVideoPlaying = true;
  bool swipedToChatList = true;
  bool isHeartAnimating = false;

  @override
  void initState() {
    log("==================================>video tile init state in ");
    /*if(_videoPlayerController.value.isInitialized)
      log("--------------------------------->already initialized");*/

    _videoPlayerController =
        CachedVideoPlayerController.network(widget.video);
    _initializeVideoPlayer = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    super.initState();
    log("==================================>video tile init state out");
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
    TextStyle style = Theme.of(context)
        .textTheme
        .bodyLarge!
        .copyWith(fontSize: 13, color: Colors.white);
    return Stack(
      children: [
        FutureBuilder(
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
                          )).then((value) {
                        _videoPlayerController.play();
                        setState(() {
                          _isVideoPlaying = true;
                        });
                      });
                    }
                  }
                },
                onDoubleTap: () {
                  log(widget.filteredList[widget.currentIndex]['postid']);
                  setState(() {
                    log("starting like animation");
                    isHeartAnimating = true;
                    widget.isLiked = true;
                  });
                  BlocProvider.of<HeartBloc>(context).add(
                      ProfilePagePostCardDoubleTapLikedAnimOnPostEvent(
                          widget.filteredList[widget.currentIndex]['postid']));
                },
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                      alignment: Alignment.center,
                      children: [
                    Center(
                        child: AspectRatio(
                            aspectRatio: _videoPlayerController.value.aspectRatio,
                            child: CachedVideoPlayer(_videoPlayerController),)),
                    Icon(
                      Icons.play_arrow,
                      color:
                      Colors.white.withOpacity(_isVideoPlaying ? 0 : 0.8),
                      size: 80,
                    ),
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

                  ]),
                ),
              );
            }
            else {
              return Container(
                alignment: Alignment.center,
                child: Lottie.asset('assets/json/tiktok.json',
                    fit: BoxFit.cover, height: 100, width: 100),
              );
            }
          },
          future: _initializeVideoPlayer,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: VideoDetails(
                  username:widget.filteredList[widget.currentIndex]['username'],
                  caption: widget.filteredList[widget.currentIndex]['caption'],
                  profileUrl: widget.filteredList[widget.currentIndex]['profileurl'],
                  UploaderUid: widget.filteredList[widget.currentIndex]['uid'],
                  isVideoPlaying: _isVideoPlaying,
                  videoPlayingController: _videoPlayerController,
                ),
              ),
            ),

            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 0.75,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3.sp, left: 28.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.filteredList[widget.currentIndex]['uid'] == FirebaseAuth.instance.currentUser!.uid
                          ? const SizedBox.shrink()
                          : _profileImageButton(),
                      const SizedBox(
                        height: 28,
                      ),
                      widget.filteredList[widget.currentIndex]['totallikes'] == 0 ?_sideBarItemForLike(CupertinoIcons.heart,"",
                          style, widget.isLiked, widget.filteredList[widget.currentIndex]['postid']) : _sideBarItemForLike(CupertinoIcons.heart, widget.filteredList[widget.currentIndex]['totallikes'].toString(),
                          style, widget.isLiked, widget.filteredList[widget.currentIndex]['postid']),
                      const SizedBox(
                        height: 20,
                      ),
                      widget.filteredList[widget.currentIndex]['totalcomments'] != 0
                          ? _sideBarForComment(CupertinoIcons.chat_bubble,
                          widget.filteredList[widget.currentIndex]['totalcomments'].toString(), style)
                          : _sideBarForComment(CupertinoIcons.chat_bubble, "", style),
                      const SizedBox(
                        height: 20,
                      ),
                      _sideBarForShare(CupertinoIcons.paperplane, 'share', style),
                      const SizedBox(
                        height: 20,
                      ),
                      _sideBarForReport(CupertinoIcons.ellipsis_vertical),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )

               /* HomeSideBar(
                  likes:widget.filteredList[widget.currentIndex]['totallikes'],
                  profileUrl: widget.filteredList[widget.currentIndex]['profileurl'],
                  PostId: widget.filteredList[widget.currentIndex]['postid'],
                  UploaderUid: widget.filteredList[widget.currentIndex]['uid'],
                  username:widget.filteredList[widget.currentIndex]['username'],
                  noofcomments:widget.filteredList[widget.currentIndex]['totalcomments'],
                  isLiked:widget.filteredList[widget.currentIndex]['likes'].contains(FirebaseAuth.instance.currentUser!.uid),
                    isHeartAnimating:isHeartAnimating,
                )*/,
              ),
            )
          ],
        )
      ],
    );
  }
  _sideBarForComment(IconData iconName, String label, TextStyle style) {
    return Column(
      children: [
        GestureDetector(
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
                      builder: (context, scrollController) => CommentSection(
                        postId:  widget.filteredList[widget.currentIndex]['postid'],
                        scrollController: scrollController,
                        username:widget.filteredList[widget.currentIndex]['username'],
                        uidofpostuploader:  widget.filteredList[widget.currentIndex]['uid'],
                      ));
                },
              );
            },
            child: Icon(iconName, size: 28)),
        const SizedBox(
          height: 5,
        ),
        label != ""
            ? Text(
          label,
          style: style,
        )
            : const SizedBox.shrink()
      ],
    );
  }

  _sideBarItemForLike(IconData iconName, String label, TextStyle style,
      bool islike, String postId) {
    return Column(
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
          child: GestureDetector(
            onTap: () {
              BlocProvider.of<HeartBloc>(context).add(
                  ProfilePagePostCardOnPressedLikedAnimOnPostEvent(postId));
              setState(() {
                if (!widget.isLiked) {
                  isHeartAnimating = true;
                }
                widget.isLiked = !widget.isLiked;
              });
            },
            child: Icon(
              size: 30,
              widget.isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: widget.isLiked ? Colors.red : Colors.white,
            ),
          ),
        ),

        const SizedBox(
          height: 5,
        ),
        label != ""
            ? Text(
          label,
          style: style,
        )
            : const SizedBox.shrink()
      ],
    );
  }

  _sideBarForShare(IconData iconName, String label, TextStyle style) {
    return Column(
      children: [
        GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      ShareScreen(Postid: widget.filteredList[widget.currentIndex]['postid'], Type: "video"),
                  constraints: const BoxConstraints(maxHeight: 400));
            },
            child: Icon(iconName, size: 26)),
        const SizedBox(
          height: 5,
        ),
        Text(
          label,
          style: style,
        )
      ],
    );
  }

  _sideBarForReport(IconData iconName) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[900],
              ),
              height: MediaQuery.of(context).size.height / 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          CupertinoIcons.xmark_circle,
                          size: 32,
                          color: Colors.grey,
                        )),
                    GestureDetector(
                      onTap: () =>  widget.filteredList[widget.currentIndex]['uid'] ==
                          FirebaseAuth.instance.currentUser!.uid
                          ? null
                          : Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: MaterialButton(
                            color: Colors.grey[900],
                            padding: const EdgeInsets.only(top: 20),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            elevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                            onPressed: () {
                              if ( widget.filteredList[widget.currentIndex]['uid'] ==
                                  FirebaseAuth
                                      .instance.currentUser!.uid) {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) =>
                                      CupertinoAlertDialog(
                                        title: const Text(
                                          "Alert !",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        content: const Text(
                                          "Are you sure you want to delete this post?",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        actions: <CupertinoDialogAction>[
                                          CupertinoDialogAction(
                                              isDestructiveAction: false,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                "No",
                                                style: TextStyle(
                                                    color: Colors.white60),
                                              )),
                                          CupertinoDialogAction(
                                              isDestructiveAction: true,
                                              onPressed: () {
                                                BlocProvider.of<ProfileBloc>(
                                                    context)
                                                    .add(DeletePostEvent(
                                                  widget.filteredList[widget.currentIndex]['postid'],
                                                ));
                                                Navigator.pop(context);
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
                                                        1000),
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
                                                          192,
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
                                                            "Deleted! ",
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
                                                            "Your reel has been deleted.",
                                                            style: TextStyle(
                                                                fontSize:
                                                                14,
                                                                color: Colors
                                                                    .white54),
                                                          ),
                                                        )
                                                      ],
                                                    )));
                                              },
                                              child: const Text("Yes")),
                                        ],
                                      ),
                                );
                              } else {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    backgroundColor: Colors.grey[900],
                                    duration: const Duration(
                                        milliseconds: 1200),
                                    elevation: 8,
                                    behavior:
                                    SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            20)),
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
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
                                widget.filteredList[widget.currentIndex]['uid'] ==
                                    FirebaseAuth
                                        .instance.currentUser!.uid
                                    ? const Icon(
                                  CupertinoIcons.delete,
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
                                widget.filteredList[widget.currentIndex]['uid'] ==
                                    FirebaseAuth
                                        .instance.currentUser!.uid
                                    ? const Text(
                                  "Delete Post",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                )
                                    : const Text(
                                  "Report",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

        },
        child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(iconName, size: 25)));
  }

  _profileImageButton() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("RegisteredUsers")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List following = snapshot.data!.get('following');
            bool isFollowing = following.contains( widget.filteredList[widget.currentIndex]['uid']);
            return GestureDetector(
              onTap: isFollowing != true
                  ? () {
                DocumentReference videoPostUser = FirebaseFirestore
                    .instance
                    .collection('RegisteredUsers')
                    .doc( widget.filteredList[widget.currentIndex]['uid']);
                videoPostUser.update({
                  'follower': FieldValue.arrayUnion(
                      [FirebaseAuth.instance.currentUser!.uid])
                });
                DocumentReference videoPostUser1 = FirebaseFirestore
                    .instance
                    .collection('RegisteredUsers')
                    .doc(FirebaseAuth.instance.currentUser!.uid);
                videoPostUser1.update({
                  'following': FieldValue.arrayUnion([ widget.filteredList[widget.currentIndex]['uid']])
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.black.withOpacity(0.8),
                    duration: const Duration(milliseconds: 800),
                    elevation: 8,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 2.5,
                      right: 120,
                      left: 120,
                    ),
                    content: Text(
                      " Following ${ widget.filteredList[widget.currentIndex]['username']}",
                      style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )));
              }
                  : () {
                DocumentReference videoPostUser = FirebaseFirestore
                    .instance
                    .collection('RegisteredUsers')
                    .doc( widget.filteredList[widget.currentIndex]['uid']);
                videoPostUser.update({
                  'follower': FieldValue.arrayRemove(
                      [FirebaseAuth.instance.currentUser!.uid])
                });
                DocumentReference videoPostUser1 = FirebaseFirestore
                    .instance
                    .collection('RegisteredUsers')
                    .doc(FirebaseAuth.instance.currentUser!.uid);
                videoPostUser1.update({
                  'following':
                  FieldValue.arrayRemove([ widget.filteredList[widget.currentIndex]['uid']])
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.black.withOpacity(0.8),
                    duration: const Duration(milliseconds: 800),
                    elevation: 8,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 2.5,
                      right: 120,
                      left: 120,
                    ),
                    content: Text(
                      " Unfollowed ${ widget.filteredList[widget.currentIndex]['username']}",
                      style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )));
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      children: [
                        widget.filteredList[widget.currentIndex]['profileurl'] != ""
                            ? CachedNetworkImage(
                          imageUrl:widget.filteredList[widget.currentIndex]['profileurl'],
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                                radius: 24.1.sp,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: imageProvider,
                                  radius: 24.sp,
                                ),
                              ),
                          placeholder: (context, url) => CircleAvatar(
                            radius: 24.1.sp,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[900],
                              radius: 24.sp,
                            ),
                          ),
                        )
                            : Center(
                          child: CircleAvatar(
                            radius: 24.1.sp,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor:
                              Colors.black.withOpacity(0.8),
                              radius: 24.sp,
                              child: Icon(Icons.person,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  isFollowing == true
                      ? Positioned(
                      bottom: -10,
                      right: 13,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 23,
                            width: 23,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const SweepGradient(colors: [
                                  Colors.pinkAccent,
                                  Colors.pinkAccent,
                                  Colors.orangeAccent,
                                  Colors.red,
                                  Colors.purple,
                                  Colors.pink,
                                ])),
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[900]),
                          ),
                          const Icon(
                            CupertinoIcons.checkmark_alt,
                            size: 12,
                          ),
                        ],
                      ))
                      : Positioned(
                      bottom: -10,
                      right: 13,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 23,
                            width: 23,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const SweepGradient(colors: [
                                  Colors.pinkAccent,
                                  Colors.pinkAccent,
                                  Colors.orangeAccent,
                                  Colors.red,
                                  Colors.purple,
                                  Colors.pink,
                                ])),
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[900]),
                          ),
                          const Icon(
                            CupertinoIcons.add,
                            size: 12,
                          ),
                        ],
                      )),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
