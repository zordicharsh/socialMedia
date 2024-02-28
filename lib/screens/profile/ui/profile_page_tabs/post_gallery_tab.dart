import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:socialmedia/screens/profile/ui/widgets/Post_card_video.dart';
import 'package:video_player/video_player.dart';

import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../navigation_handler/bloc/navigation_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../widgets/animated_dialog.dart';
import '../widgets/post_card.dart';

class PostGallery extends StatefulWidget {
  const PostGallery({super.key, required this.profileimage,});

  final String profileimage;


  @override
  State<PostGallery> createState() => _PostGalleryState();
}

class _PostGalleryState extends State<PostGallery> {
  @override
  void initState() {
    super.initState();
  }
  VideoPlayerController? videoPlayerController;

  @override
  Widget build(BuildContext context) {
    late OverlayEntry popupDialog;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfilePageFetchUserPostSuccessState) {
          return StreamBuilder<QuerySnapshot>(
            stream: state.postdata,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
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
              else if (snapshot.hasError) {
                log("error while loading post :- ${snapshot.hasError.toString()}");
                return Text(snapshot.hasError.toString());
              }
              final posts = snapshot.data!;
              if (posts.docs.isEmpty) {
                return GestureDetector(
                  onTap: () => BlocProvider.of<NavigationBloc>(context).add(TabChangedEvent(tabIndex: 2)),
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
              }
              else {
                return GridView.builder(
                  itemCount: posts.size,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 1),
                  itemBuilder: (context, index) {
                    if( posts.docs[index]['type'] == 'image')
                      {
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
                              onLongPressEnd: (details) => popupDialog.remove(),
                              onTap: () {
                                if(widget.profileimage != ""){
                                  Navigator.push(
                                      context,
                                      CustomPageRouteRightToLeft(
                                          child: PostCard(
                                              currentImageIndex: posts.docs[index]['posturl'].toString(),username: posts.docs[index]['username'].toString(),profileimage: widget.profileimage,likes: posts.docs[index]['likes'].toString(),caption: posts.docs[index]['caption'].toString(),uploadtime: posts.docs[index]['uploadtime'])));
                                }else{
                                  Navigator.push(
                                      context,
                                      CustomPageRouteRightToLeft(
                                          child: PostCard(
                                              currentImageIndex: posts.docs[index]['posturl'].toString(),username: posts.docs[index]['username'].toString(),profileimage: widget.profileimage,likes: posts.docs[index]['likes'].toString(),caption: posts.docs[index]['caption'].toString(),uploadtime: posts.docs[index]['uploadtime'])));
                                }

                              },
                              child: Image.network(
                                posts.docs[index]['posturl'].toString(),
                                fit: BoxFit.cover,
                              )),
                        );
                      }
                    else
                      {  videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(posts.docs[index]['posturl'].toString()))
                        ..initialize()
                        ..pause();
                      return Container(
                        color: Colors.grey.withOpacity(0.2),
                        child: GestureDetector(
                            onLongPress: (){
                              popupDialog = _createPopupDialog(
                                  posts.docs[index]['posturl'].toString(),
                                  posts.docs[index]['profileurl'].toString(),
                                  posts.docs[index]['username']);
                              Overlay.of(context).insert(popupDialog);
                            },
                            onLongPressEnd: (details) => popupDialog.remove(),
                            onTap: () {
                              if(widget.profileimage != ""){
                                Navigator.push(
                                    context,
                                    CustomPageRouteRightToLeft(
                                        child: PostCardVideo(
                                            currentImageIndex: posts.docs[index]['posturl'].toString(),username: posts.docs[index]['username'].toString(),profileimage: widget.profileimage,likes: posts.docs[index]['likes'].toString(),caption: posts.docs[index]['caption'].toString(),uploadtime: posts.docs[index]['uploadtime'])));
                              }else{
                                Navigator.push(
                                    context,
                                    CustomPageRouteRightToLeft(
                                        child: PostCard(
                                            currentImageIndex: posts.docs[index]['posturl'].toString(),username: posts.docs[index]['username'].toString(),profileimage: widget.profileimage,likes: posts.docs[index]['likes'].toString(),caption: posts.docs[index]['caption'].toString(),uploadtime: posts.docs[index]['uploadtime'])));
                              }
                            },
                            child:VideoPlayer(videoPlayerController!)),
                      );

                      }
                    
                  },
                );
              }

            },
          );
        }
        else if (state is ProfilePageFetchUserDataLoadingState) {
          return  Shimmer(
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
        else {
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
                  child: Image.network(url, fit: BoxFit.cover,filterQuality: FilterQuality.high,)),
              _createActionBar(),
            ],
          ),
        ),
      );

  Widget _createPhotoTitle(String profileurl, String username) => Container(
      width: double.infinity,
      color: Colors.grey[900],
      child:  ListTile(
        leading: widget.profileimage != "" ?
        CircleAvatar(
          radius: 14.1,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage:
            NetworkImage(widget.profileimage),
            radius: 14,
          ),
        ):
        CircleAvatar(
          radius: 14.1,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.8),
            radius: 14,
            child: Icon(Icons.person,color: Colors.black.withOpacity(0.5)),
          ),
        ),
        title: Text(
          username,
         // "hi",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));

  Widget _createActionBar() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.grey[900],
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
            Icon(
              Icons.chat_bubble_outline_outlined,
              color: Colors.white,
            ),
            Icon(
              Icons.send,
              color: Colors.white,
            ),
          ],
        ),
      );
}
