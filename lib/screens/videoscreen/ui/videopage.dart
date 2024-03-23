import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/videoscreen/bloc/refresh_bloc.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/home_side_bar.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/video_details.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/video_tile.dart';

class VideoPage extends StatefulWidget {
  final postid;
  final uid;
  const VideoPage({super.key, this.uid, this.postid});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<Color> colors = [];
  bool IsFollowingSelected = false;
  int _snappedPageIndex=0;

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
              Text("For you",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: IsFollowingSelected ?14:18,color: IsFollowingSelected?Colors.grey:Colors.white)),
            ],
          ),
          leading: null,
        ),
        body:StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("UserPost")
              .where('acctype', isEqualTo: "public")
              .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .where('type', isEqualTo: "video")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> filteredList = [];
              List<DocumentSnapshot> otherVideos = [];
              snapshot.data!.docs.forEach((doc) {
                if (doc['postid'] == widget.postid && doc['uid'] == widget.uid) {
                  print("loduuu");
                  filteredList.add(doc);
                } else {
                  otherVideos.add(doc);
                }
              });
              // Concatenate the filtered list with other videos
              filteredList.addAll(otherVideos);
              return PageView.builder(
                onPageChanged: (int page) {
                  setState(() {
                    _snappedPageIndex = page;
                  });
                },
                scrollDirection: Axis.vertical,
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoTile(
                        video: filteredList[index]['posturl'],
                        currentIndex: index,
                        snappedPageIndex: _snappedPageIndex,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 4,
                              child: VideoDetails(
                                username: filteredList[index]['username'],
                                caption: filteredList[index]['caption'],
                                UploaderUid: filteredList[index]['uid'],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.75,
                              child: HomeSideBar(
                                likes: filteredList[index]['likes'],
                                profileUrl: filteredList[index]['profileurl'],
                                PostId: filteredList[index]['postid'],
                                UploaderUid: filteredList[index]['uid'],
                                username:filteredList[index]['username'],
                                noofcomments:filteredList[index]['totalcomments'],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  );
                },
              );
            } else {
              return Container(
                color: Colors.white,
              );
            }
          },
        )

    );

  }
}



