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
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_bloc.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_event.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_state.dart';
import 'package:socialmedia/screens/profile/ui/widgets/comment.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../../chat_screen/sharelist.dart';
import '../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../search_user/searchui/searched_profile/anotherprofile.dart';

class ExplorePageImage extends StatefulWidget {
  final String uid;
  final String postuid;

  const ExplorePageImage({super.key, required this.uid, required this.postuid});

  @override
  State<ExplorePageImage> createState() => _ExplorePageImageState();
}

class _ExplorePageImageState extends State<ExplorePageImage> {
  late Stream<DocumentSnapshot> _currentUserDataStream;
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<exploreimageBloc>(context).add(imagedisplayEvent());
    getCurrentUserDataStream();
  }

  getCurrentUserDataStream() {
    return _currentUserDataStream = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.postuid);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text("Explore"),
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: BlocBuilder<exploreimageBloc, exploreimageState>(
              builder: (context, state) {
                if (state is exploreimageshowState) {
                  return StreamBuilder(
                    stream: state.UserPostData,
                    builder: (context, snapshotStream) {
                      if (snapshotStream.hasData) {
                        log("huiiienxpected");
                        List<Widget> postWidgets = [];
                        for (var snapshot in snapshotStream.data!.docs) {
                          final postData = snapshot.data();
                          final postID = postData['postid'];
                          final profileUrl = postData['profileurl'];
                          final username = postData['username'];
                          final postUrl = postData['posturl'];
                          final postType = postData['type'];
                          final caption = postData['caption'];
                          final uploadTime = postData['uploadtime'];
                          List likes = postData['likes'];
                          final upuid = postData['uid'];
                          final noofcomments = postData['totalcomments'];
                          //this is main post
                          // Check if the current post matches the provided postuid
                          if (postID == widget.postuid) {
                            final islike = likes.contains(
                                FirebaseAuth.instance.currentUser!.uid);
                            log(islike.toString());
                            Widget mainPostWidget = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Post header (user information)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 4, right: 8, left: 12),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            CustomPageRouteRightToLeft(child: AnotherUserProfile(uid: upuid, username:username),
                                            ),),
                                          child: Row(
                                            children: [
                                              profileUrl != ""
                                                  ? CachedNetworkImage(
                                                      imageUrl: profileUrl,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          CircleAvatar(
                                                        radius: 14.1.sp,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey,
                                                          backgroundImage:
                                                              imageProvider,
                                                          radius: 14.sp,
                                                        ),
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 14.1.sp,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors
                                                            .black
                                                            .withOpacity(0.8),
                                                        radius: 14.sp,
                                                        child: Icon(Icons.person,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5)),
                                                      ),
                                                    ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                username,
                                                // Replace with actual username
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ), //username
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
                                                            Padding(
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
                                                                    if ( upuid == FirebaseAuth.instance.currentUser!.uid) {
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
                                                                                            postID,
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
                                                                      upuid ==
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
                                                                     upuid ==
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.transparent);
                                              },
                                              icon: const Icon(
                                                  Icons.more_vert_sharp),
                                              color: Colors.white,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ), //post Title

                                // Post image or video
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.45,
                                  width: double.infinity,
                                  child: ZoomOverlay(
                                    modalBarrierColor: Colors.black12,
                                    minScale: 0.5,
                                    maxScale: 3.0,
                                    animationCurve: Curves.fastOutSlowIn,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    twoTouchOnly: true,
                                    onScaleStart: () {},
                                    onScaleStop: () {},
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Image(
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                              image: CachedNetworkImageProvider(
                                                  postUrl),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ), //post

                                // Post actions (like, comment, share, save)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          highlightColor: Colors.transparent,
                                          onPressed: () {
                                            if (islike) {
                                              DocumentReference currentUserRef =
                                                  FirebaseFirestore.instance
                                                      .collection('UserPost')
                                                      .doc(postID);
                                              currentUserRef.update({
                                                'likes':
                                                    FieldValue.arrayRemove([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ])
                                              });
                                            } else {
                                              DocumentReference currentUserRef =
                                                  FirebaseFirestore.instance
                                                      .collection('UserPost')
                                                      .doc(postID);
                                              currentUserRef.update({
                                                'likes': FieldValue.arrayUnion([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ])
                                              });
                                            }
                                          },
                                          icon: islike
                                              ? const Icon(
                                                  CupertinoIcons.heart_fill,
                                                  color: Colors.redAccent,
                                                )
                                              : const Icon(
                                                  CupertinoIcons.heart),
                                        ),
                                        IconButton(
                                          highlightColor: Colors.transparent,
                                          icon: const Icon(
                                            CupertinoIcons.chat_bubble,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return DraggableScrollableSheet(
                                                    snap: true,
                                                    snapSizes: const [
                                                      0.71,
                                                      0.72
                                                    ],
                                                    maxChildSize: 0.96,
                                                    initialChildSize: 0.96,
                                                    minChildSize: 0.4,
                                                    builder: (context,
                                                            scrollController) =>
                                                        CommentSection(
                                                          postId: postID,
                                                          scrollController:
                                                              scrollController,
                                                          username: username,
                                                          uidofpostuploader:
                                                              upuid,
                                                        ));
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          highlightColor: Colors.transparent,
                                          icon: const Icon(
                                            CupertinoIcons.paperplane,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    ShareScreen(
                                                        Postid: postID,
                                                        Type: postType),
                                                constraints: const BoxConstraints(
                                                    maxHeight: 400));
                                          },
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
                                ), //action button

                                // Display the number of likes
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 12),
                                  child: Text("${likes.length} likes"),
                                ), //like stats

                                const SizedBox(height: 4),

                                // Display post caption
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 16),
                                    child: ReadMoreText(
                                      caption,
                                      delimiter: '...',
                                      preDataText: username,
                                      preDataTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
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

                                //comments
                                noofcomments > 2
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0,
                                            right: 12,
                                            left: 12,
                                            bottom: 4),
                                        child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return DraggableScrollableSheet(
                                                      snap: true,
                                                      snapSizes: const [
                                                        0.71,
                                                        0.72
                                                      ],
                                                      maxChildSize: 0.96,
                                                      initialChildSize: 0.96,
                                                      minChildSize: 0.4,
                                                      builder: (context,
                                                              scrollController) =>
                                                          CommentSection(
                                                            postId: postID,
                                                            scrollController:
                                                                scrollController,
                                                            username: username,
                                                            uidofpostuploader:
                                                                upuid,
                                                          ));
                                                },
                                              );
                                            },
                                            child: Text(
                                                "View all $noofcomments comments",
                                                style: const TextStyle(
                                                    color: Colors.white60))),
                                      )
                                    : Row(
                                        children: [
                                          StreamBuilder(
                                            stream: _currentUserDataStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: CircleAvatar(
                                                    radius: 12.1,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.8),
                                                      radius: 12,
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Text("error");
                                              } else {
                                                var userData =
                                                    snapshot.data!.data()
                                                        as Map<String, dynamic>;
                                                return userData['profileurl'] !=
                                                        ""
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: userData[
                                                              'profileurl'],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              CircleAvatar(
                                                            radius: 12.1,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              backgroundImage:
                                                                  imageProvider,
                                                              radius: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12.0),
                                                        child: CircleAvatar(
                                                          radius: 12.1,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.8),
                                                            radius: 12,
                                                            child: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5)),
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
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (context) {
                                                    return DraggableScrollableSheet(
                                                        snap: true,
                                                        snapSizes: const [
                                                          0.71,
                                                          0.72
                                                        ],
                                                        maxChildSize: 0.96,
                                                        initialChildSize: 0.96,
                                                        minChildSize: 0.4,
                                                        builder: (context,
                                                                scrollController) =>
                                                            CommentSection(
                                                              postId: postID,
                                                              scrollController:
                                                                  scrollController,
                                                              username:
                                                                  username,
                                                              uidofpostuploader:
                                                                  upuid,
                                                            ));
                                                  },
                                                );
                                              },
                                              decoration: InputDecoration(
                                                hintText: upuid ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid
                                                    ? 'Add a comment...'
                                                    : 'Add a comment for $username...',
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

                                //Date
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 12),
                                  child: Text(
                                      DateFormat.d()
                                          .add_yMMM()
                                          .format(uploadTime.toDate()),
                                      style: const TextStyle(
                                          color: Colors.white60)),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            );
                            postWidgets.add(mainPostWidget);
                            //loading provider;
                          }
                        }

                        // Add additional images below the main post
                        for (var snapshot in snapshotStream.data!.docs) {
                          final postData = snapshot.data();
                          final postID = postData['postid'];
                          final profileUrl = postData['profileurl'];
                          final username = postData['username'];
                          final postUrl = postData['posturl'];
                          final postType = postData['type'];
                          final caption = postData['caption'];
                          final uploadTime = postData['uploadtime'];
                          final likes = postData['likes'];
                          final upuid = postData['uid'];
                          final noofcomments = postData['totalcomments'];
                          // Check if the post is an image and not the main post
                          if (postID != widget.postuid && postType == "image") {
                            final islike = likes.contains(
                                FirebaseAuth.instance.currentUser!.uid);
                            Widget mainPostWidget = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Post header (user information)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, bottom: 4, right: 8, left: 12),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            CustomPageRouteRightToLeft(child: AnotherUserProfile(uid: upuid, username:username),
                                            ),),
                                          child: Row(
                                            children: [
                                              profileUrl != ""
                                                  ? CachedNetworkImage(
                                                      imageUrl: profileUrl,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          CircleAvatar(
                                                        radius: 14.1.sp,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.grey,
                                                          backgroundImage:
                                                              imageProvider,
                                                          radius: 14.sp,
                                                        ),
                                                      ),
                                                    )
                                                  : CircleAvatar(
                                                      radius: 14.1.sp,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors
                                                            .black
                                                            .withOpacity(0.8),
                                                        radius: 14.sp,
                                                        child: Icon(Icons.person,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5)),
                                                      ),
                                                    ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Text(
                                                username,
                                                // Replace with actual username
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ), //username
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
                                                            Padding(
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
                                                                    if ( upuid == FirebaseAuth.instance.currentUser!.uid) {
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
                                                                                            postID,
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
                                                                      upuid ==
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
                                                                      upuid ==
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.transparent);
                                              },
                                              icon: const Icon(
                                                  Icons.more_vert_sharp),
                                              color: Colors.white,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ), //post Title

                                // Post image or video
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.45,
                                  width: double.infinity,
                                  child: ZoomOverlay(
                                    modalBarrierColor: Colors.black12,
                                    minScale: 0.5,
                                    maxScale: 3.0,
                                    animationCurve: Curves.fastOutSlowIn,
                                    animationDuration:
                                        const Duration(milliseconds: 300),
                                    twoTouchOnly: true,
                                    onScaleStart: () {},
                                    onScaleStop: () {},
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Image(
                                              fit: BoxFit.cover,
                                              filterQuality: FilterQuality.high,
                                              image: CachedNetworkImageProvider(
                                                  postUrl),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ), //post

                                // Post actions (like, comment, share, save)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          highlightColor: Colors.transparent,
                                          onPressed: () {
                                            if (islike) {
                                              DocumentReference currentUserRef =
                                                  FirebaseFirestore.instance
                                                      .collection('UserPost')
                                                      .doc(postID);
                                              currentUserRef.update({
                                                'likes':
                                                    FieldValue.arrayRemove([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ])
                                              });
                                            } else {
                                              DocumentReference currentUserRef =
                                                  FirebaseFirestore.instance
                                                      .collection('UserPost')
                                                      .doc(postID);
                                              currentUserRef.update({
                                                'likes': FieldValue.arrayUnion([
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                                ])
                                              });
                                            }
                                          },
                                          icon: islike
                                              ? const Icon(
                                                  CupertinoIcons.heart_fill,
                                                  color: Colors.redAccent,
                                                )
                                              : const Icon(
                                                  CupertinoIcons.heart),
                                        ),
                                        IconButton(
                                          highlightColor: Colors.transparent,
                                          icon: const Icon(
                                            CupertinoIcons.chat_bubble,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              context: context,
                                              builder: (context) {
                                                return DraggableScrollableSheet(
                                                    snap: true,
                                                    snapSizes: const [
                                                      0.71,
                                                      0.72
                                                    ],
                                                    maxChildSize: 0.96,
                                                    initialChildSize: 0.96,
                                                    minChildSize: 0.4,
                                                    builder: (context,
                                                            scrollController) =>
                                                        CommentSection(
                                                          postId: postID,
                                                          scrollController:
                                                              scrollController,
                                                          username: username,
                                                          uidofpostuploader:
                                                              upuid,
                                                        ));
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          highlightColor: Colors.transparent,
                                          icon: const Icon(
                                            CupertinoIcons.paperplane,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    ShareScreen(
                                                        Postid: postID,
                                                        Type: postType),
                                                constraints: const BoxConstraints(
                                                    maxHeight: 400));
                                          },
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
                                ), //action button

                                // Display the number of likes
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 12),
                                  child: Text("${likes.length} likes"),
                                ), //like stats

                                const SizedBox(height: 4),

                                // Display post caption
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 16),
                                    child: ReadMoreText(
                                      caption,
                                      delimiter: '...',
                                      preDataText: username,
                                      preDataTextStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
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

                                //comments
                                noofcomments > 2
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0,
                                            right: 12,
                                            left: 12,
                                            bottom: 4),
                                        child: GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return DraggableScrollableSheet(
                                                      snap: true,
                                                      snapSizes: const [
                                                        0.71,
                                                        0.72
                                                      ],
                                                      maxChildSize: 0.96,
                                                      initialChildSize: 0.96,
                                                      minChildSize: 0.4,
                                                      builder: (context,
                                                              scrollController) =>
                                                          CommentSection(
                                                            postId: postID,
                                                            scrollController:
                                                                scrollController,
                                                            username: username,
                                                            uidofpostuploader:
                                                                upuid,
                                                          ));
                                                },
                                              );
                                            },
                                            child: Text(
                                                "View all $noofcomments comments",
                                                style: const TextStyle(
                                                    color: Colors.white60))),
                                      )
                                    : Row(
                                        children: [
                                          StreamBuilder(
                                            stream: _currentUserDataStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: CircleAvatar(
                                                    radius: 12.1,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: CircleAvatar(
                                                      backgroundColor: Colors
                                                          .black
                                                          .withOpacity(0.8),
                                                      radius: 12,
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return const Text("error");
                                              } else {
                                                var userData =
                                                    snapshot.data!.data()
                                                        as Map<String, dynamic>;
                                                return userData['profileurl'] !=
                                                        ""
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12.0),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: userData[
                                                              'profileurl'],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              CircleAvatar(
                                                            radius: 12.1,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              backgroundImage:
                                                                  imageProvider,
                                                              radius: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12.0),
                                                        child: CircleAvatar(
                                                          radius: 12.1,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.8),
                                                            radius: 12,
                                                            child: Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5)),
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
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (context) {
                                                    return DraggableScrollableSheet(
                                                        snap: true,
                                                        snapSizes: const [
                                                          0.71,
                                                          0.72
                                                        ],
                                                        maxChildSize: 0.96,
                                                        initialChildSize: 0.96,
                                                        minChildSize: 0.4,
                                                        builder: (context,
                                                                scrollController) =>
                                                            CommentSection(
                                                              postId: postID,
                                                              scrollController:
                                                                  scrollController,
                                                              username:
                                                                  username,
                                                              uidofpostuploader:
                                                                  upuid,
                                                            ));
                                                  },
                                                );
                                              },
                                              decoration: InputDecoration(
                                                hintText: upuid ==
                                                        FirebaseAuth.instance
                                                            .currentUser?.uid
                                                    ? 'Add a comment...'
                                                    : 'Add a comment for $username...',
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

                                //Date
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 12),
                                  child: Text(
                                      DateFormat.d()
                                          .add_yMMM()
                                          .format(uploadTime.toDate()),
                                      style: const TextStyle(
                                          color: Colors.white60)),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            );
                            postWidgets.add(mainPostWidget);
                          }
                        }
                        // Return the assembled list of widgets
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: postWidgets,
                        );
                      } else if (snapshotStream.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: Colors.grey[900],
                        ));
                      } else {
                        log("no data");
                        return Container(); // Return an empty container if no data is available
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
  }
}
