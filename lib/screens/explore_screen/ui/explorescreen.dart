import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/exploreimage/ui/exploreimagepage.dart';
import '../../../common_widgets/single_item_state/single(popup_dialog)state.dart';
import '../../chat_screen/sharelist.dart';
import '../../profile/bloc/heart_animation_bloc/heart_bloc.dart';
import '../../profile/ui/widgets/animated_dialog.dart';
import '../../profile/ui/widgets/comment.dart';
import '../../search_user/ui/searchui.dart';
import '../../videos_screen/ui/videopage.dart';

class AllUserPosts extends StatefulWidget {
  const AllUserPosts({super.key});

  @override
  State<AllUserPosts> createState() => _AllUserPostsState();
}

class _AllUserPostsState extends State<AllUserPosts> {
  CachedVideoPlayerController? controller;
  bool islike = false;
  bool isloading = false;
  late OverlayEntry popupDialog;
  bool gettingmoreData = false;
  bool moreuserdataavailable = true;
  QuerySnapshot? querySnapshot2;
  final like = GlobalKey<TooltipState>();
  final comment = GlobalKey<TooltipState>();
  final share = GlobalKey<TooltipState>();
  bool isHeartAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Row(
            children: [
              Icon(CupertinoIcons.compass),
              SizedBox(
                width: 8,
              ),
              Text(
                "Discover",
              ),
            ],
          ),
          surfaceTintColor: Colors.black,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    CustomPageRouteRightToLeft(child: const SearchUser()));
              },
              icon: const Icon(Icons.search),
            )
          ]),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("UserPost")
            .where('acctype', isEqualTo: 'public')
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LiquidPullToRefresh(
              color: Colors.grey.withOpacity(0.15),
              backgroundColor: Colors.white.withOpacity(0.65),
              animSpeedFactor: 1.5,
              borderWidth: 1,
              height: 70,
              springAnimationDurationInMilliseconds: 150,
              showChildOpacityTransition: false,
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final isLiked = snapshot.data!.docs[index]['likes']
                              .contains(FirebaseAuth.instance.currentUser!.uid);

                          if (snapshot.data!.docs[index]['type'] == "image") {
                            return GestureDetector(
                                onLongPress: () {
                                  popupDialog = _createPopupDialog(
                                      index,
                                      snapshot.data,
                                      like,
                                      comment,
                                      share,
                                      isLiked,
                                      isHeartAnimating);
                                  Overlay.of(context).insert(popupDialog);
                                },
                                onLongPressMoveUpdate: (details) async {
                                  log(details.globalPosition.toString());
                                  if ((details.globalPosition.dx >= 85 &&
                                          details.globalPosition.dx <= 150) &&
                                      (details.globalPosition.dy >= 660 &&
                                          details.globalPosition.dy <= 680)) {
                                    log("user like the post from else if(89)");
                                    like.currentState?.ensureTooltipVisible();
                                    log("making tooltip visible");
                                  } else if ((details.globalPosition.dx >=
                                              180 &&
                                          details.globalPosition.dx <= 225) &&
                                      (details.globalPosition.dy >= 660 &&
                                          details.globalPosition.dy <= 680)) {
                                    log("user comment the post from else if(108)");
                                    comment.currentState
                                        ?.ensureTooltipVisible();
                                    log("making comment tooltip visible");
                                  } else if ((details.globalPosition.dx >=
                                              285 &&
                                          details.globalPosition.dx <= 325) &&
                                      (details.globalPosition.dy >= 660 &&
                                          details.globalPosition.dy <= 680)) {
                                    log("user shared the post from else if(108)");
                                    share.currentState?.ensureTooltipVisible();
                                    log("making share tooltip visible");
                                  } else {
                                    Tooltip.dismissAllToolTips()
                                        ? log("all tooltip being removed")
                                        : log("no tooltip inside widget tree");
                                  }
                                },
                                onLongPressEnd: (details) async {
                                  Tooltip.dismissAllToolTips();
                                  await Future.delayed(
                                      const Duration(milliseconds: 60));
                                  if ((details.globalPosition.dx >= 85 &&
                                          details.globalPosition.dx <= 150) &&
                                      (details.globalPosition.dy >= 660 &&
                                          details.globalPosition.dy <= 680)) {
                                    HapticFeedback.vibrate();
                                    if (!context.mounted) return;
                                    BlocProvider.of<HeartBloc>(context).add(
                                        ProfilePagePopUpDialogLikedAnimOnPostEvent(
                                            isHeartAnimating, isLiked));
                                    BlocProvider.of<HeartBloc>(context).add(
                                        ProfilePagePostCardOnPressedLikedAnimOnPostEvent(
                                            snapshot.data!.docs[index]
                                                ['postid']));
                                    if (!isLiked) {
                                      await Future.delayed(
                                          const Duration(milliseconds: 600));
                                    } else {
                                      await Future.delayed(
                                          const Duration(milliseconds: 150));
                                    }
                                    popupDialog.remove();
                                    setState(() {});
                                  } else if ((details.globalPosition.dx >=
                                              180 &&
                                          details.globalPosition.dx <= 225) &&
                                      (details.globalPosition.dy >= 660 &&
                                          details.globalPosition.dy <= 680)) {
                                    HapticFeedback.vibrate();
                                    popupDialog.remove();
                                    setState(() {});
                                    if (!context.mounted) return;
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
                                            builder: (context,
                                                    scrollController) =>
                                                CommentSection(
                                                  postId: snapshot.data!
                                                      .docs[index]['postid'],
                                                  scrollController:
                                                      scrollController,
                                                  username: snapshot.data!
                                                      .docs[index]['username'],
                                                  uidofpostuploader: snapshot
                                                      .data!.docs[index]['uid'],
                                                ));
                                      },
                                    );
                                  } else if ((details.globalPosition.dx >=
                                              285 &&
                                          details.globalPosition.dx <= 325) &&
                                      (details.globalPosition.dy >= 660 &&
                                          details.globalPosition.dy <= 680)) {
                                    HapticFeedback.vibrate();
                                    popupDialog.remove();
                                    setState(() {});
                                    if (!context.mounted) return;
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) => ShareScreen(
                                            Postid: snapshot.data!.docs[index]
                                                ['postid'],
                                            Type: snapshot.data!.docs[index]
                                                ['type']),
                                        constraints: const BoxConstraints(
                                            maxHeight: 400));
                                  } else {
                                    popupDialog.remove();
                                    setState(() {});
                                  }
                                },
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          CustomPageRouteRightToLeft(
                                              child: ExplorePageImage(
                                                  uid: snapshot
                                                      .data!.docs[index]['uid'],
                                                  postuid: snapshot.data!
                                                      .docs[index]['postid'])))
                                      .then((value) {
                                    setState(() {});
                                  });
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.docs[index]
                                          ['posturl'],
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.low,
                                      width: double.infinity,
                                      height: double.infinity,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                    )));
                          } else {
                            return GestureDetector(
                              onLongPress: () {
                                popupDialog = _createPopupDialog(
                                    index,
                                    snapshot.data,
                                    like,
                                    comment,
                                    share,
                                    isLiked,
                                    isHeartAnimating);
                                Overlay.of(context).insert(popupDialog);
                              },
                              onLongPressMoveUpdate: (details) async {
                                log(details.globalPosition.toString());
                                if ((details.globalPosition.dx >= 85 &&
                                        details.globalPosition.dx <= 150) &&
                                    (details.globalPosition.dy >= 760 &&
                                        details.globalPosition.dy <= 780)) {
                                  log("user like the post from else if(89)");
                                  like.currentState?.ensureTooltipVisible();
                                  log("making tooltip visible");
                                } else if ((details.globalPosition.dx >= 180 &&
                                        details.globalPosition.dx <= 225) &&
                                    (details.globalPosition.dy >= 760 &&
                                        details.globalPosition.dy <= 780)) {
                                  log("user comment the post from else if(108)");
                                  comment.currentState?.ensureTooltipVisible();
                                  log("making comment tooltip visible");
                                } else if ((details.globalPosition.dx >= 285 &&
                                        details.globalPosition.dx <= 325) &&
                                    (details.globalPosition.dy >= 760 &&
                                        details.globalPosition.dy <= 780)) {
                                  log("user shared the post from else if(108)");
                                  share.currentState?.ensureTooltipVisible();
                                  log("making share tooltip visible");
                                } else {
                                  Tooltip.dismissAllToolTips()
                                      ? log("all tooltip being removed")
                                      : log("no tooltip inside widget tree");
                                }
                              },
                              onLongPressEnd: (details) async {
                                Tooltip.dismissAllToolTips();
                                await Future.delayed(
                                    const Duration(milliseconds: 60));
                                if ((details.globalPosition.dx >= 85 &&
                                        details.globalPosition.dx <= 150) &&
                                    (details.globalPosition.dy >= 760 &&
                                        details.globalPosition.dy <= 780)) {
                                  HapticFeedback.vibrate();
                                  if (!context.mounted) return;
                                  BlocProvider.of<HeartBloc>(context).add(
                                      ProfilePagePopUpDialogLikedAnimOnPostEvent(
                                          isHeartAnimating, isLiked));
                                  BlocProvider.of<HeartBloc>(context).add(
                                      ProfilePagePostCardOnPressedLikedAnimOnPostEvent(
                                          snapshot.data!.docs[index]
                                              ['postid']));
                                  if (!isLiked) {
                                    await Future.delayed(
                                        const Duration(milliseconds: 600));
                                  } else {
                                    await Future.delayed(
                                        const Duration(milliseconds: 150));
                                  }
                                  popupDialog.remove();
                                  setState(() {});
                                } else if ((details.globalPosition.dx >= 180 &&
                                        details.globalPosition.dx <= 225) &&
                                    (details.globalPosition.dy >= 760 &&
                                        details.globalPosition.dy <= 780)) {
                                  HapticFeedback.vibrate();
                                  popupDialog.remove();
                                  setState(() {});
                                  if (!context.mounted) return;
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
                                          builder: (context,
                                                  scrollController) =>
                                              CommentSection(
                                                postId: snapshot.data!
                                                    .docs[index]['postid'],
                                                scrollController:
                                                    scrollController,
                                                username: snapshot.data!
                                                    .docs[index]['username'],
                                                uidofpostuploader: snapshot
                                                    .data!.docs[index]['uid'],
                                              ));
                                    },
                                  );
                                } else if ((details.globalPosition.dx >= 285 &&
                                        details.globalPosition.dx <= 325) &&
                                    (details.globalPosition.dy >= 760 &&
                                        details.globalPosition.dy <= 780)) {
                                  HapticFeedback.vibrate();
                                  popupDialog.remove();
                                  setState(() {});
                                  if (!context.mounted) return;
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) => ShareScreen(
                                          Postid: snapshot.data!.docs[index]
                                              ['postid'],
                                          Type: snapshot.data!.docs[index]
                                              ['type']),
                                      constraints:
                                          const BoxConstraints(maxHeight: 400));
                                } else {
                                  popupDialog.remove();
                                  setState(() {});
                                }
                              },
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CustomPageRouteRightToLeft(
                                        child: VideoPage(
                                              uid: snapshot.data!.docs[index]
                                                  ['uid'],
                                              postid: snapshot.data!.docs[index]
                                                  ['postid'],
                                            ))).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                          imageUrl: snapshot.data!.docs[index]
                                              ['thumbnail'],
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.low,
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (context, url) =>
                                              Container(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                              ))),
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.video_library,
                                      // Replace Icons.close with your desired icon
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }, childCount: snapshot.data!.size),
                        gridDelegate: SliverQuiltedGridDelegate(
                            crossAxisCount: 3,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                            pattern: [
                              const QuiltedGridTile(2, 1),
                              const QuiltedGridTile(2, 2),
                              const QuiltedGridTile(1, 1),
                              const QuiltedGridTile(1, 1),
                              const QuiltedGridTile(1, 1),
                            ])),
                    SliverToBoxAdapter(
                        child: isloading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white))
                            : const SizedBox())
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  OverlayEntry _createPopupDialog(
      int index,
      QuerySnapshot<Map<String, dynamic>>? postdata,
      GlobalKey<TooltipState> likeState,
      GlobalKey<TooltipState> commentState,
      GlobalKey<TooltipState> shareState,
      bool isLiked,
      bool isHeartAnimating) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
          child: SinglePopupDialogState(
        index: index,
        postdata: postdata,
        likeState: likeState,
        commentState: commentState,
        shareState: shareState,
        isHeartAnimating: isHeartAnimating,
      )),
    );
  }

  Future<void> _refresh() {
     setState(() {});
    return Future.delayed(const Duration(seconds: 1));
  }
}
