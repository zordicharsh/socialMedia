import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:readmore/readmore.dart';
import 'package:socialmedia/common_widgets/like_animation_widget/like_animation_widget.dart';

import '../../screens/profile/bloc/comment_bloc/comment_bloc.dart';

class SingleCommentCardItemState extends StatefulWidget {
  final int index;
  final QuerySnapshot commentdata;
  final String postId;
  final String uidofpostuploader;

  const SingleCommentCardItemState(
      {super.key,
      required this.index,
      required this.commentdata,
      required this.postId, required this.uidofpostuploader});

  @override
  State<SingleCommentCardItemState> createState() =>
      _SingleCommentCardItemStateState();
}

class _SingleCommentCardItemStateState
    extends State<SingleCommentCardItemState> {
  bool isHeartAnimating = false;
  late bool isLiked;


  @override
  void initState() {
    isLiked = widget.commentdata.docs[widget.index]['likes']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu.builder(
      builder: (context, animation) => GestureDetector(
        onDoubleTap: () {
          log("double tap detected on a comment");
          setState(() {
            log("starting like animation");
            isHeartAnimating = true;
            isLiked = true;
          });
          BlocProvider.of<CommentBloc>(context).add(
              PostCardCommentSectionDoubleTapLikedAnimOnCommentEvent(
                  widget.postId,
                  widget.commentdata.docs[widget.index]['commentid']));
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          clipBehavior: Clip.none,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12 * animation.value),
            child: Container(
              width: 316.h,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              color: Colors.grey[900],
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                borderOnForeground: false,
                color: Colors.grey[900],
                child: ListTile(
                  title: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.commentdata.docs[widget.index]['profileurl'] !=
                                  ""
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.commentdata
                                        .docs[widget.index]['profileurl']
                                        .toString(),
                                    placeholder: (context, url) => CircleAvatar(
                                      radius: 18.1,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
                                        radius: 20,
                                      ),
                                    ),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 18.1,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage: imageProvider,
                                        radius: 20,
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: CircleAvatar(
                                    radius: 18.1,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Colors.black.withOpacity(0.8),
                                      radius: 20,
                                      child: Icon(Icons.person,
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.commentdata
                                          .docs[widget.index]['username']
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 8),
                                      child: Text(
                                          Jiffy.parse(widget.commentdata
                                                      .docs[widget.index]
                                                  ['uploadtime'])
                                              .fromNow(),
                                          style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 8.8.sp)),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                ReadMoreText(
                                  widget.commentdata.docs[widget.index]['text']
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                  delimiter: '...',
                                  trimCollapsedText: 'View More',
                                  trimExpandedText: '  View Less',
                                  trimMode: TrimMode.Length,
                                  trimLength: 500,
                                  moreStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white60,
                                  ),
                                  lessStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: HeartAnimationWidget(
                                  isAnimating: isLiked,
                                  alwaysAnimate: true,
                                  duration: const Duration(milliseconds: 150),
                                  onEnd: () {
                                    if (!isLiked) {
                                      setState(() {
                                        isHeartAnimating = false;
                                      });
                                    }
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<CommentBloc>(context).add(
                                          PostCardCommentSectionOnPressedLikedAnimOnCommentEvent(
                                              widget.postId,
                                              widget.commentdata
                                                      .docs[widget.index]
                                                  ['commentid']));
                                      setState(() {
                                        if (!isLiked) {
                                          isHeartAnimating = true;
                                        }
                                        isLiked = !isLiked;
                                      });
                                    },
                                    child: Icon(
                                      isLiked
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color:
                                          isLiked ? Colors.red : Colors.white54,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              widget.commentdata.docs[widget.index]
                                          ['totallikes'] >
                                      0
                                  ? Text(
                                      "${widget.commentdata.docs[widget.index]['totallikes']}",
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white54),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      enableHapticFeedback: true,
      actions: [
        if(widget.uidofpostuploader == FirebaseAuth.instance.currentUser!.uid)
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.pin,
          child: const Text("Pin"),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(
                context)
                .showSnackBar(SnackBar(
                backgroundColor:
                Colors
                    .black,
                duration:
                const Duration(
                    milliseconds:
                    1200),
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
                      224,
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
                        "Premium! ",
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
                        "Buy premium to pin upto 3 comments.",
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
        ),
        if(!(widget.commentdata.docs[widget.index]['uid'] == FirebaseAuth.instance.currentUser!.uid))
        CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.exclamationmark_triangle,
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                  context)
                  .showSnackBar(SnackBar(
                  backgroundColor:
                  Colors
                      .black,
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
                        248,
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
            },
            child: const Text("Report")),
        if(widget.commentdata.docs[widget.index]['uid'] == FirebaseAuth.instance.currentUser!.uid || widget.uidofpostuploader == FirebaseAuth.instance.currentUser!.uid)
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.delete,
          isDestructiveAction: true,
          onPressed: () async {
            Navigator.pop(context);
            ScaffoldMessenger.of(
                context)
                .showSnackBar(SnackBar(
                backgroundColor:
                Colors
                    .black,
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
                      224,
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
                        "Your comment has been deleted.",
                        style: TextStyle(
                            fontSize:
                            14,
                            color: Colors
                                .white54),
                      ),
                    )
                  ],
                )));
            BlocProvider.of<CommentBloc>(context).add(DeleteCommentsOfUserPost(
                widget.commentdata.docs[widget.index]['commentid'].toString(),
                widget.postId));

          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
