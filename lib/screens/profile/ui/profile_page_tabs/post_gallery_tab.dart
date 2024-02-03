import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:socialmedia/screens/navigation_handler/bloc/navigation_bloc.dart';
import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../bloc/profile_bloc.dart';
import '../widgets/animated_dialog.dart';
import '../widgets/post_card.dart';

class PostGallery extends StatefulWidget {
  const PostGallery({super.key});

  @override
  State<PostGallery> createState() => _PostGalleryState();
}

class _PostGalleryState extends State<PostGallery> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late OverlayEntry popupDialog;
   /* final currentUserID = FirebaseAuth.instance.currentUser!.uid;
    final postdata = _getCurrentUserPosts(
        currentUserID);
    setState(() {});*/

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if(state is ProfilePageFetchUserPostSuccessState) {
          return StreamBuilder<QuerySnapshot>(
            stream: state.postdata,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer(
                  duration: const Duration(milliseconds: 1200), //Default value
                  interval: const Duration(milliseconds: 200), //Default value: Duration(seconds: 0)
                  color: Colors.white, //Default value
                  colorOpacity: 0, //Default value
                  enabled: true, //Default value
                  direction: const ShimmerDirection.fromLTRB(),
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
                        color: Colors.grey.withOpacity(0.2),
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
                return Positioned(
                  top: 4000.sp,
                  child: GestureDetector(
                    onTap: ()=>BlocProvider.of<NavigationBloc>(context).add(TabChangedEvent(tabIndex: 2)),
                    child: const Center(
                      child: Tooltip(
                        message:'Tap to upload a post on your profile',
                        enableFeedback: true,
                        verticalOffset: -68,
                        waitDuration: Duration(milliseconds: 600),
                        showDuration:Duration(milliseconds: 400),
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
                            Text("Upload a Post",style: TextStyle(fontSize: 16),),
                          ],
                        ),
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
                    return Container(
                      color: Colors.grey.withOpacity(0.2),
                      child: GestureDetector(
                          onLongPress: () {
                            popupDialog = _createPopupDialog(
                                posts.docs[index]['posturl'].toString(),posts.docs[index]['profileurl'],posts.docs[index]['username']);
                            Overlay.of(context).insert(popupDialog);
                          },
                          onLongPressEnd: (details) => popupDialog.remove(),
                          onTap: () {
                            Navigator.push(
                                context,
                                CustomPageRouteRightToLeft(
                                    child: PostCard(
                                        currentImageIndex: posts.docs[index]
                                                ['posturl']
                                            .toString())));
                          },
                          child: Image.network(
                            posts.docs[index]['posturl'].toString(),
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                );
              }
            },
          );
        }else if(state is ProfilePageFetchUserDataLoadingState){
          return Shimmer(
            duration: const Duration(milliseconds: 1200), //Default value
            interval: const Duration(milliseconds: 200), //Default value: Duration(seconds: 0)
            color: Colors.white, //Default value
            colorOpacity: 0, //Default value
            enabled: true, //Default value
            direction: const ShimmerDirection.fromLTRB(),
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
                  color: Colors.grey.withOpacity(0.2),
                );
              },
            ),
          );
        }else{
          return Shimmer(
            duration: const Duration(milliseconds: 12000), //Default value
            interval: const Duration(milliseconds: 200), //Default value: Duration(seconds: 0)
            color: Colors.white, //Default value
            colorOpacity: 0, //Default value
            enabled: true, //Default value
            direction: const ShimmerDirection.fromLTRB(),
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
                  color: Colors.grey.withOpacity(0.2),
                );
              },
            ),
          );
        }
      },
    );
  }


  OverlayEntry _createPopupDialog(String url,String profileurl,String username) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(child: _createPopupContent(url,profileurl,username)),
    );
  }

  Widget _createPopupContent(String url,String profileurl,String username) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(profileurl,username),
              Container(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  color: Colors.black,
                  child: Image.network(url, fit: BoxFit.cover)),
              _createActionBar(),
            ],
          ),
        ),
      );

  Widget _createPhotoTitle(String profileurl,String username) =>
      Container(
          width: double.infinity,
          color: Colors.grey[900],
          child: const ListTile(
            leading: CircleAvatar(
              radius: 14.1,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
            //    backgroundImage: NetworkImage(profileurl),
                radius: 14,
              ),
            ),
            title: Text(
             // username,
              "hi",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ));

  Widget _createActionBar() =>
      Container(
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

 /* _getCurrentUserPosts(String? uid) {
    log("uid in gallery $uid");
    var posts = FirebaseFirestore.instance
        .collection("UserPost")
        .where("uid", isEqualTo: uid.toString()).snapshots();
    return posts;
  }*/


}

