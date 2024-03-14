import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_bloc.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_event.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_state.dart';
import 'package:socialmedia/screens/profile/ui/widgets/comment.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class ExplorePageImage extends StatefulWidget {
  final uid;
  final postuid;

  const ExplorePageImage({super.key, required this.uid, required this.postuid});

  @override
  State<ExplorePageImage> createState() => _ExplorePageImageState();
}

class _ExplorePageImageState extends State<ExplorePageImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<exploreimageBloc>(context).add(imagedisplayEvent());
  }

  @override
  Widget build(BuildContext context) {
    print(widget.postuid);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
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
                        print("huiiienxpected");
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
                            print(islike.toString());
                            Widget mainPostWidget = Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Post header (user information)
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(profileUrl),
                                    ),
                                    title: Text(username),
                                    trailing: const Icon(Icons.more_vert_sharp),
                                  ),
                                  // Post image or video
                                  postType == "image"
                                      ? ZoomOverlay(
                                          modalBarrierColor: Colors.black12,
                                          minScale: 0.5,
                                          maxScale: 3.0,
                                          animationCurve: Curves.fastOutSlowIn,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          twoTouchOnly: true,
                                          onScaleStart: () {},
                                          onScaleStop: () {},
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: postUrl,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(), // Handle video case
                                  // Post actions (like, comment, share, save)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (islike) {
                                            DocumentReference currentUserRef =
                                                FirebaseFirestore.instance
                                                    .collection('UserPost')
                                                    .doc(postID);
                                            currentUserRef.update({
                                              'likes': FieldValue.arrayRemove([
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
                                                Icons.favorite,
                                                color: Colors.redAccent,
                                              )
                                            : const Icon(
                                                Icons.favorite_outline),
                                      ),
                                      IconButton(
                                        onPressed: () {
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
                                                        postId: postID,
                                                        scrollController:
                                                            scrollController,
                                                        username: username,
                                                        uidofpostuploader:
                                                            upuid,
                                                      ));
                                            },
                                          );
                                          // Implement comment functionality
                                        },
                                        icon: const Icon(
                                            Icons.chat_bubble_outline_outlined),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Implement share functionality
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          // Implement save functionality
                                        },
                                        icon: const Icon(Icons.bookmark_border),
                                      ),
                                    ],
                                  ),
                                  // Display the number of likes
                                  Text(
                                    "${likes.length} likes",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
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
                                                    postId: postID,
                                                    scrollController:
                                                        scrollController,
                                                    username: username,
                                                    uidofpostuploader: upuid,
                                                  ));
                                        },
                                      );
                                    },
                                    child: Text(
                                      "view ${noofcomments.toString()} comment",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                  // Display post caption
                                  Row(
                                    children: [
                                      Text(
                                        username,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        caption,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(uploadTime!.toDate().toUtc()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
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
                          final upid = postData['uid'];
                          final upuid = postData['uid'];
                          final noofcomments = postData['totalcomments'];
                          // Check if the post is an image and not the main post
                          if (postID != widget.postuid && postType == "image") {
                            final islike = likes.contains(
                                FirebaseAuth.instance.currentUser!.uid);
                            Widget mainPostWidget = Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Post header (user information)
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(profileUrl),
                                    ),
                                    title: Text(username),
                                    trailing: const Icon(Icons.more_vert_sharp),
                                  ),
                                  // Post image or video
                                  postType == "image"
                                      ? ZoomOverlay(
                                          modalBarrierColor: Colors.black12,
                                          minScale: 0.5,
                                          maxScale: 3.0,
                                          animationCurve: Curves.fastOutSlowIn,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          twoTouchOnly: true,
                                          onScaleStart: () {},
                                          onScaleStop: () {},
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: postUrl,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  // Handle video case
                                  // Post actions (like, comment, share, save)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (islike) {
                                            DocumentReference currentUserRef =
                                                FirebaseFirestore.instance
                                                    .collection('UserPost')
                                                    .doc(postID);
                                            currentUserRef.update({
                                              'likes': FieldValue.arrayRemove([
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
                                                Icons.favorite,
                                                color: Colors.redAccent,
                                              )
                                            : const Icon(
                                                Icons.favorite_outline),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Implement comment functionality
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
                                                        postId: postID,
                                                        scrollController:
                                                            scrollController,
                                                        username: username,
                                                        uidofpostuploader: upid,
                                                      ));
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.chat_bubble_outline_outlined),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          // Implement share functionality
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          // Implement save functionality
                                        },
                                        icon: const Icon(Icons.bookmark_border),
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(height: 8),
                                  // Display the number of likes
                                  Text(
                                    "${likes.length} likes",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Display post caption
                                  GestureDetector(
                                    onTap: () {
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
                                                    postId: postID,
                                                    scrollController:
                                                        scrollController,
                                                    username: username,
                                                    uidofpostuploader: upuid,
                                                  ));
                                        },
                                      );
                                    },
                                    child: Text(
                                      "view ${noofcomments.toString()} comment",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        username,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        caption,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(uploadTime!.toDate().toUtc()),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
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
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        print("no data");
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
