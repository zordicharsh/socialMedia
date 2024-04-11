import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/screens/videos_screen/ui/widgets/video_tile.dart';
import '../../../model/user_model.dart';

class VideoPage extends StatefulWidget {
  final String postid;
  final String uid;
  final String fromWhere;
  final List<UserModel> userdata;

  const VideoPage({
    super.key,
    this.postid = "",
    this.uid = "",
    this.fromWhere = "",this.userdata = const [],
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Color> colors = [];
  int _snappedPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.fromWhere != 'profileScreen' && widget.fromWhere != 'homeScreen'
                  ? Text("For you",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold))
                  : const SizedBox.shrink(),
            ],
          ),
          leading: null,
        ),
        body: StreamBuilder(
          stream: widget.fromWhere != 'profileScreen' && widget.fromWhere != 'homeScreen'
              ? FirebaseFirestore.instance
                  .collection("UserPost")
                  .where('acctype', isEqualTo: "public")
                  .where('type', isEqualTo: "video")
                  .orderBy('uploadtime', descending: true)
                  .snapshots()

              : widget.fromWhere == 'profileScreen'
              ? FirebaseFirestore.instance
                  .collection('UserPost')
                  .where('uid',
                      isEqualTo:widget.uid)
                  .where('type', isEqualTo: 'video')
                  .orderBy('uploadtime', descending: true)
                  .snapshots()

              : FirebaseFirestore.instance
              .collection("UserPost")
              .where('uid', whereIn: widget.userdata[0].Following)
              .where('type', isEqualTo: "video")
              .orderBy("uploadtime", descending: true)
              .snapshots(),

          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> filteredList = [];
              List<DocumentSnapshot> otherVideos = [];
              for (var doc in snapshot.data!.docs) {
                if (doc['postid'] == widget.postid &&
                    doc['uid'] == widget.uid) {
                  filteredList.add(doc);
                } else {
                  otherVideos.add(doc);
                }
              }
              // Concatenate the filtered list with other videos
              filteredList.addAll(otherVideos);
              return PageView.builder(
                onPageChanged: (int page) {
                  setState(() {
                    _snappedPageIndex = page;
                  });
                },
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoTile(
                        video: filteredList[index]['posturl'],
                        currentIndex: index,
                        filteredList: filteredList,
                        snappedPageIndex: _snappedPageIndex,
                        isLiked: filteredList[index]['likes']
                            .contains(FirebaseAuth.instance.currentUser!.uid),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ));
  }
}
