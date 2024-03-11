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
import 'package:jiffy/jiffy.dart';
import 'package:socialmedia/common_widgets/like_animation_widget/like_animation_widget.dart';
import '../../bloc/comment_bloc/comment_bloc.dart';

class SingleCommentCardItemState extends StatefulWidget {
  final int index;
  final QuerySnapshot commentdata;
  final String postId;
  const SingleCommentCardItemState({super.key, required this.index, required this.commentdata, required this.postId});

  @override
  State<SingleCommentCardItemState> createState() => _SingleCommentCardItemStateState();
}

class _SingleCommentCardItemStateState extends State<SingleCommentCardItemState> {
  bool isHeartAnimating = false;
  late bool isLiked ;

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
                  widget.postId, widget.commentdata.docs[widget.index]['commentid']));
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
                          widget.commentdata.docs[widget.index]['profileurl'].toString() != ""
                              ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: CachedNetworkImage(
                              imageUrl: widget.commentdata.docs[widget.index]['profileurl']
                                  .toString(),
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
                                    widget.commentdata.docs[widget.index]['username'].toString(),
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ), Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8),
                                      child: Text(
                                       Jiffy.parse(
                                           widget.commentdata.docs[widget.index]['uploadtime']).fromNow(),
                                          style: TextStyle(color: Colors.white60,fontSize: 8.8.sp)),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 4,
                                ),
                                ReadMoreText(
                                  widget.commentdata.docs[widget.index]['text'].toString(),
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
                                              widget.commentdata.docs[widget.index]['commentid']));
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
                                      color: isLiked ? Colors.red : Colors.white54,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              widget.commentdata.docs[widget.index]['totallikes'] > 0 ?
                              Text("${widget.commentdata.docs[widget.index]['totallikes']}",style: const TextStyle(fontSize: 10,fontWeight: FontWeight.bold,  color: Colors.white54),) : const SizedBox.shrink(),
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
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.pin,
          child: const Text("Pin"),
          onPressed: () {},
        ),
        CupertinoContextMenuAction(
            trailingIcon: CupertinoIcons.exclamationmark_triangle,
            isDestructiveAction: true,
            onPressed: () {},
            child: const Text("Report")),
        CupertinoContextMenuAction(
          trailingIcon: CupertinoIcons.delete,
          isDestructiveAction: true,
          onPressed: () async {
          /*  log("------------------>${snapshot.docs[index]['commentid'].toString()}");*/
            Navigator.pop(context);
            BlocProvider.of<CommentBloc>(context).add(DeleteCommentsOfUserPost(
                widget.commentdata.docs[widget.index]['commentid'].toString(), widget.postId));
            // await Future.delayed(const Duration (milliseconds:250));
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
