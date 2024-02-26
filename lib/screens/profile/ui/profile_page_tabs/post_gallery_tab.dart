import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../navigation_handler/bloc/navigation_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../widgets/animated_dialog.dart';
import '../widgets/post_card.dart';

class PostGallery extends StatefulWidget {
  const PostGallery({
    super.key,
    required this.profileimage,
  });

  final String profileimage;

  @override
  State<PostGallery> createState() => _PostGalleryState();
}

class _PostGalleryState extends State<PostGallery> {
  late OverlayEntry popupDialog;
  final like = GlobalKey<TooltipState>();
  final comment = GlobalKey<TooltipState>();
  final share = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfilePageFetchUserPostSuccessState) {
          return StreamBuilder<QuerySnapshot>(
            stream: state.postdata,
            builder: (context, snapshot) {
              final posts = snapshot.data;
              if (state.postlength == 0) {
                return GestureDetector(
                  onTap: () => BlocProvider.of<NavigationBloc>(context)
                      .add(TabChangedEvent(tabIndex: 2)),
                  child: const Center(
                    child: Tooltip(
                      message: 'Tap to upload a post on your profile',
                      enableFeedback: true,
                      verticalOffset: -68,
                      waitDuration: Duration(milliseconds: 600),
                      showDuration: Duration(milliseconds: 200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_box_rounded,
                            size: 32,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Upload a Post",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: posts!.size,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: GestureDetector(
                          onLongPress: () {
                            popupDialog = _createPopupDialog(
                                posts.docs[index]['posturl'].toString(),
                                posts.docs[index]['profileurl'].toString(),
                                posts.docs[index]['username']);
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
                            }
                            else if ((details.globalPosition.dx >= 285 &&
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
                          onLongPressEnd: (details) => popupDialog.remove(),
                          onTap: () {
                            if (widget.profileimage != "") {
                              Navigator.push(
                                  context,
                                  CustomPageRouteRightToLeft(
                                      child: PostCard(
                                          currentImageIndex: posts.docs[index]
                                                  ['posturl']
                                              .toString(),
                                          username: posts.docs[index]
                                                  ['username']
                                              .toString(),
                                          profileimage: widget.profileimage,
                                          likes: posts.docs[index]['likes']
                                              .toString(),
                                          caption: posts.docs[index]['caption']
                                              .toString(),
                                          uploadtime: posts.docs[index]
                                              ['uploadtime'])));
                            } else {
                              Navigator.push(
                                  context,
                                  CustomPageRouteRightToLeft(
                                      child: PostCard(
                                          currentImageIndex: posts.docs[index]
                                                  ['posturl']
                                              .toString(),
                                          username: posts.docs[index]
                                                  ['username']
                                              .toString(),
                                          profileimage: widget.profileimage,
                                          likes: posts.docs[index]['likes']
                                              .toString(),
                                          caption: posts.docs[index]['caption']
                                              .toString(),
                                          uploadtime: posts.docs[index]
                                              ['uploadtime'])));
                            }
                          },
                          child: CachedNetworkImage(
                            imageUrl: posts.docs[index]['posturl'].toString(),
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer(
                  duration: const Duration(milliseconds: 2500),
                  //Default value
                  // interval: const Duration(milliseconds: 100000),
                  //Default value: Duration(seconds: 0)
                  color: Colors.white.withOpacity(0.5),
                  //Default value
                  colorOpacity: 0.1,
                  //Default value
                  enabled: true,
                  //Default value
                  direction: const ShimmerDirection.fromLeftToRight(),
                  child: GridView.builder(
                    itemCount: 12,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                            childAspectRatio: 1),
                    itemBuilder: (context, index) {
                      return Container(
                        color: Colors.grey.withOpacity(0.1),
                      );
                    },
                  ),
                );
              } else {
                log("error while loading post :- ${snapshot.hasError.toString()}");
                return Text(snapshot.hasError.toString());
              }
            },
          );
        } else {
          return Shimmer(
            duration: const Duration(milliseconds: 2500),
            //Default value
            // interval: const Duration(milliseconds: 100000),
            //Default value: Duration(seconds: 0)
            color: Colors.white.withOpacity(0.5),
            //Default value
            colorOpacity: 0.1,
            //Default value
            enabled: true,
            //Default value
            direction: const ShimmerDirection.fromLeftToRight(),
            child: GridView.builder(
              itemCount: 12,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey.withOpacity(0.1),
                );
              },
            ),
          );
        }
      },
    );
  }

  OverlayEntry _createPopupDialog(
      String url, String profileurl, String username) {
    return OverlayEntry(
      builder: (context) =>
          AnimatedDialog(child: _createPopupContent(url, profileurl, username)),
    );
  }

  Widget _createPopupContent(String url, String profileurl, String username) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(profileurl, username),
              Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.415,
                  color: Colors.black,
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  )),
              _createActionBar(),
            ],
          ),
        ),
      );

  Widget _createPhotoTitle(String profileurl, String username) => Container(
      width: double.infinity,
      color: Colors.grey[900],
      child: ListTile(
        leading: widget.profileimage != ""
            ? CircleAvatar(
                radius: 14.1,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.profileimage),
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
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           Tooltip(
              key: like,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
              ),
             textStyle: const TextStyle(color: Colors.white),
              preferBelow: false,
              verticalOffset: 40,
              showDuration: const Duration(seconds: 0),
              enableFeedback: true,
              message: "Like",
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            ),
            Tooltip(
              key: comment,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
              ),
              textStyle: const TextStyle(color: Colors.white),
              preferBelow: false,
              verticalOffset: 40,
              showDuration: const Duration(seconds: 0),
              enableFeedback: true,
              message: "Comment",
              child: const Icon(
                Icons.chat_bubble_outline_outlined,
                color: Colors.white,
              ),
            ),
            Tooltip(
              key: share,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
              ),
              textStyle: const TextStyle(color: Colors.white),
              preferBelow: false,
              verticalOffset: 40,
              showDuration: const Duration(seconds: 0),
              enableFeedback: true,
              message: "Share",
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
}
