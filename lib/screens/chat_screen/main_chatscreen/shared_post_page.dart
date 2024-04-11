import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../common_widgets/single_item_state/single(post_card)state.dart';
import '../../../common_widgets/single_item_state/single(video_post_card)state.dart';

class SharedPostInChatItemState extends StatefulWidget {
  const SharedPostInChatItemState({super.key, required this.postdata});

  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> postdata;

  @override
  State<SharedPostInChatItemState> createState() =>
      _SharedPostInChatItemStateState();
}

class _SharedPostInChatItemStateState extends State<SharedPostInChatItemState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 32,
        ),
        backgroundColor: Colors.black,
        title: const Text(
          "SocialRizz",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('UserPost')
            .where('postid', isEqualTo: widget.postdata.data!.get('postid'))
            .snapshots(),
        builder: (context, snapshot) {
          final postsdata = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.grey,
            ));
          } else if (snapshot.hasError) {
            return const Center(child: Text("error"));
          } else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: postsdata!.size,
                itemBuilder: (context, index) {
                  bool isLiked = snapshot.data!.docs[index]['likes']
                      .contains(FirebaseAuth.instance.currentUser!.uid);
                  return snapshot.data!.docs[index]['type'] == 'image'
                      ? SingleImagePostCardItemState(
                          postdata: postsdata.docs[index].data(),
                          isLiked: isLiked,
                        )
                      : SingleVideoPostCardItemState(
                          postdata: postsdata.docs[index].data(),
                          isLiked: isLiked,
                        );
                });
          }
        },
      ),
    );
  }
}
