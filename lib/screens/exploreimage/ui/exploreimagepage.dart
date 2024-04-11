import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_bloc.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_event.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_state.dart';

import '../../../common_widgets/single_item_state/single(post_card)state.dart';


class ExplorePageImage extends StatefulWidget {
  final String uid;
  final String postuid;

  const ExplorePageImage({super.key, required this.uid, required this.postuid});

  @override
  State<ExplorePageImage> createState() => _ExplorePageImageState();
}

class _ExplorePageImageState extends State<ExplorePageImage> {
  TextEditingController comment = TextEditingController();


  @override
  void initState() {
    super.initState();
    BlocProvider.of<exploreimageBloc>(context).add(imagedisplayEvent());
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
                        List<Widget> postWidgets = [];
                        for (var snapshot in snapshotStream.data!.docs) {
                          final postData = snapshot.data();
                          final postID = postData['postid'];
                          List likes = postData['likes'];


                          //this is main post, Check if the current post matches the provided postuid
                          if (postID == widget.postuid) {
                            Widget mainPostWidget = SingleImagePostCardItemState(postdata:postData,isLiked:likes.contains(FirebaseAuth.instance.currentUser!.uid));
                            postWidgets.add(mainPostWidget);
                            //loading provider;
                          }
                        }

                        // Add additional images below the main post
                        for (var snapshot in snapshotStream.data!.docs) {
                          final postData = snapshot.data();
                          final postID = postData['postid'];
                          final postType = postData['type'];
                          final likes = postData['likes'];

                          // Check if the post is an image and not the main post
                          if (postID != widget.postuid && postType == "image") {

                            Widget mainPostWidget = SingleImagePostCardItemState(postdata:postData,isLiked:likes.contains(FirebaseAuth.instance.currentUser!.uid));
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
                        return const SizedBox.shrink();
                      } else {
                        return const SizedBox.shrink(); // Return an empty container if no data is available
                      }
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ));
  }
}
