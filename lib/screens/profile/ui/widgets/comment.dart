import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:socialmedia/screens/profile/bloc/comment_bloc/comment_bloc.dart';
import 'package:socialmedia/screens/profile/ui/widgets/single(comment_card)state.dart';

class CommentSection extends StatefulWidget {
  final ScrollController scrollController;
  final String profileImage;
  final String username;
  final String postId;
  final String uidofpostuploader;

  const CommentSection(
      {super.key,
      required this.profileImage,
      required this.username,
      required this.postId,required this.scrollController,required this.uidofpostuploader});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final comment = TextEditingController();
  bool emojiShowing = true;
  bool isCommentShareButtonVisible = false;

  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CommentBloc>(context)
        .add(FetchCommentsOfUserPost(widget.postId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(children: [
          Column(
            children: [
              Visibility(
                visible: emojiShowing ? true : false,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      comment.text = comment.text + emoji.emoji.substring(0, 0);
                      log(comment.text);
                    });
                    _showCommentShareButton(comment.text);
                  },
                  textEditingController: comment,
                  config: Config(
                    height: 45,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor: const Color(0xFF212121),
                      emojiSizeMax: 24 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.20
                              : 1.0),
                    ),
                    swapCategoryAndBottomBar: false,
                    skinToneConfig: const SkinToneConfig(
                      enabled: true,
                      dialogBackgroundColor: Color(0xFF212121),
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: const Color(0xFF212121),
                      initCategory: Category.SMILEYS,
                      recentTabBehavior: RecentTabBehavior.NONE,
                      customCategoryView:
                          (config, state, tabController, pageController) =>
                              const SizedBox(),
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                      customBottomActionBar: (config, state, showSearchView) =>
                          const SizedBox(),
                    ),
                    searchViewConfig: SearchViewConfig(
                      customSearchView: (config, state, showEmojiView) =>
                          const SizedBox(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    widget.profileImage != ""
                        ? CachedNetworkImage(
                          imageUrl: widget.profileImage,
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
                        )
                        : CircleAvatar(
                          radius: 18.1,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.8),
                            radius: 20,
                            child: Icon(Icons.person,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 40.h,
                      width: 224.w,
                      child: TextField(
                        style: TextStyle(fontSize: 12.sp),
                        onChanged: (value) => _showCommentShareButton(value),
                        controller: comment,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText:widget.uidofpostuploader == FirebaseAuth.instance.currentUser?.uid ? 'Add a comment...':
                          'Add a comment for ${widget.username}...',
                          hintStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 28,
                    ),
                    Visibility(
                      replacement: GestureDetector(
                        onTap: () {
                          log("---------------->hi");
                          setState(() {
                            isCommentShareButtonVisible = false;
                          });
                          BlocProvider.of<CommentBloc>(context)
                              .add(UploadCommentsOfUserPost(
                            widget.postId,
                            comment.text.toString().trim(),
                          ));
                          comment.clear();
                          log("---------------->wow");
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 34,
                              width: 34,
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
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey[900]),
                            ),
                            const Icon(
                              Icons.arrow_upward_sharp,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      visible: !isCommentShareButtonVisible,
                      child: Container(
                        width: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Center(
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.emoji_emotions_outlined,
                              size: 22,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                log("emoji pressed");
                                emojiShowing = !emojiShowing;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        child: Container(
          color: Colors.grey[900],
          child: Stack(children: [
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white60,
                      ),
                      width: 30.w,
                      height: 3.h,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Text(
                      "Comments",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    Divider(
                      height: 20,
                      color: Colors.white12.withOpacity(0.05),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<CommentBloc, CommentState>(
              builder: (context, state) {
                if (state is FetchCommentsOfUserPostSuccessState) {
                  return Padding(
                    padding: EdgeInsets.only(top: 44.h),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: state.commentdata,
                      builder: (context, snapshot) {
                        final commentdata = snapshot.data;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (commentdata!.size == 0) {
                          return Center(
                            child: Container(
                              color: Colors.black,
                              width: double.infinity,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No comments yet",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "Start the conversation.",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: const BouncingScrollPhysics(),
                            controller: widget.scrollController,
                            itemCount: commentdata.size,
                            itemBuilder: (context, index) =>
                                SingleCommentCardItemState(index:index,commentdata:commentdata,postId: widget.postId),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
  _showCommentShareButton(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isCommentShareButtonVisible = true;
      });
      return true;
    }
    setState(() {
      isCommentShareButtonVisible = false;
    });
    return false;
  }
}
