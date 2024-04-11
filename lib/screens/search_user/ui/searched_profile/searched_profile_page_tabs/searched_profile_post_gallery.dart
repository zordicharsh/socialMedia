import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common_widgets/single_item_state/single(popup_dialog)state.dart';
import '../../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../../profile/bloc/heart_animation_bloc/heart_bloc.dart';
import '../../../../profile/ui/widgets/animated_dialog.dart';
import '../../../../profile/ui/widgets/comment.dart';
import '../../../../profile/ui/widgets/post_card.dart';

class SearchedProfilePostGallery extends StatefulWidget {
  const SearchedProfilePostGallery({super.key, required this.uid});

  final String uid;

  @override
  State<SearchedProfilePostGallery> createState() => _SearchedProfilePostGalleryState();
}

class _SearchedProfilePostGalleryState extends State<SearchedProfilePostGallery> {
  late OverlayEntry popupDialog;
  final like = GlobalKey<TooltipState>();
  final comment = GlobalKey<TooltipState>();
  final share = GlobalKey<TooltipState>();
  bool isHeartAnimating = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("UserPost")/*.where("type",isEqualTo: "image")*/
                .where("uid", isEqualTo: widget.uid.toString()).orderBy('uploadtime',descending: true)
                .snapshots(),
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                log("error while loading post :- ${snapshot.hasError.toString() }");
                return Text(snapshot.hasError.toString());

              }
              else if (snapshot.hasData) {
                final posts = snapshot.data ;
                return posts!.size == 0 ?
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 42,
                          child: Icon(
                            CupertinoIcons.camera,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "No posts yet",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
                    :GridView.builder(
                  itemCount: posts.size,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    final  isLiked = posts.docs[index]['likes']
                        .contains(FirebaseAuth.instance.currentUser!.uid);
                    if (posts.docs[index]['type'] == 'image') {
                      return Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: GestureDetector(
                            onLongPress: () {
                              popupDialog = _createPopupDialog(
                                  index,posts,like,comment,share,isLiked,isHeartAnimating
                              );
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
                              } else if ((details.globalPosition.dx >= 180 &&
                                  details.globalPosition.dx <= 225) &&
                                  (details.globalPosition.dy >= 660 &&
                                      details.globalPosition.dy <= 680)) {
                                log("user comment the post from else if(108)");
                                comment.currentState?.ensureTooltipVisible();
                                log("making comment tooltip visible");
                              } else if ((details.globalPosition.dx >= 285 &&
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
                              await Future.delayed(const Duration(milliseconds: 60));
                              if ((details.globalPosition.dx >= 85 &&
                                  details.globalPosition.dx <= 150) &&
                                  (details.globalPosition.dy >= 660 &&
                                      details.globalPosition.dy <= 680)) {
                                HapticFeedback.vibrate();
                                if(!context.mounted) return;
                                BlocProvider.of<HeartBloc>(context).add(
                                    ProfilePagePopUpDialogLikedAnimOnPostEvent(
                                        isHeartAnimating, isLiked)
                                );
                                BlocProvider.of<HeartBloc>(context).add(ProfilePagePostCardOnPressedLikedAnimOnPostEvent(
                                    posts.docs[index]['postid']));
                                if (!isLiked) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 600));
                                } else {
                                  await Future.delayed(
                                      const Duration(milliseconds: 150));
                                }
                                popupDialog.remove();
                              }
                              else if ((details.globalPosition.dx >= 180 &&
                                  details.globalPosition.dx <= 225) &&
                                  (details.globalPosition.dy >= 660 &&
                                      details.globalPosition.dy <= 680)){
                                HapticFeedback.vibrate();
                                popupDialog.remove();
                                if(!context.mounted) return;
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
                                              postId: posts
                                                  .docs[index]['postid'],
                                              scrollController: scrollController,
                                              username: posts
                                                  .docs[index]['username'],
                                              uidofpostuploader:
                                              posts.docs[index]['uid'],
                                            ));
                                  },
                                );
                              }
                              else {
                                popupDialog.remove();
                              }
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRouteRightToLeft(
                                    child: PostCard(
                                      currentImageIndex: index,
                                      uid:widget.uid ,
                                    ),
                                  ));
                            },
                            child: CachedNetworkImage(
                              imageUrl: posts.docs[index]['posturl'].toString(),
                              fit: BoxFit.cover,
                            )),
                      );
                    }
                    else {
                      return Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: GestureDetector(
                            onLongPress: () {
                              popupDialog = _createPopupDialog(
                                  index,posts,like,comment,share,isLiked,isHeartAnimating
                              );
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
                              await Future.delayed(const Duration(milliseconds: 60));
                              if ((details.globalPosition.dx >= 85 &&
                                  details.globalPosition.dx <= 150) &&
                                  (details.globalPosition.dy >= 760 &&
                                      details.globalPosition.dy <= 780)) {
                                HapticFeedback.vibrate();
                                if(!context.mounted) return;
                                BlocProvider.of<HeartBloc>(context).add(
                                    ProfilePagePopUpDialogLikedAnimOnPostEvent(
                                        isHeartAnimating, isLiked));
                                BlocProvider.of<HeartBloc>(context).add(ProfilePagePostCardOnPressedLikedAnimOnPostEvent(
                                    posts.docs[index]['postid']));
                                if (!isLiked) {
                                  await Future.delayed(
                                      const Duration(milliseconds: 600));
                                } else {
                                  await Future.delayed(
                                      const Duration(milliseconds: 150));
                                }
                                popupDialog.remove();
                              }
                              else if ((details.globalPosition.dx >= 180 &&
                                  details.globalPosition.dx <= 225) &&
                                  (details.globalPosition.dy >= 760 &&
                                      details.globalPosition.dy <= 780)) {
                                HapticFeedback.vibrate();
                                popupDialog.remove();
                                if(!context.mounted) return;
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
                                              postId: posts
                                                  .docs[index]['postid'],
                                              scrollController: scrollController,
                                              username: posts
                                                  .docs[index]['username'],
                                              uidofpostuploader:
                                              posts.docs[index]['uid'],
                                            ));
                                  },
                                );
                              }

                              else {
                                popupDialog.remove();
                              }
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRouteRightToLeft(
                                    child: PostCard(
                                      currentImageIndex: index,
                                      uid:widget.uid ,
                                    ),
                                  ));
                            },
                            child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      posts.docs[index]['thumbnail'].toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const Icon(Icons.video_library,size: 20)
                                ]
                            )),
                      );
                    }
                  },
                );
              }
              else {
                return const SizedBox.shrink();
              }

            },
          );

  }

  OverlayEntry _createPopupDialog(int index,QuerySnapshot<Map<String, dynamic>>? postdata,GlobalKey<TooltipState> likeState,GlobalKey<TooltipState> commentState,GlobalKey<TooltipState> shareState,bool isLiked,bool isHeartAnimating) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
          child:SinglePopupDialogState(index: index,postdata: postdata,likeState:likeState ,commentState: commentState,shareState:shareState,isHeartAnimating: isHeartAnimating,)),
    );
  }


}
