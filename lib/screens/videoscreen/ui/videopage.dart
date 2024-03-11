import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    if (widget.postid == null && widget.uid == null) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              GestureDetector(onTap: (){
                setState(() {
                  IsFollowingSelected = true;
                });
              },child: Text("Following",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: IsFollowingSelected ?18:14,color: IsFollowingSelected?Colors.white:Colors.grey),)),
              Text(" | ",style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18,color: Colors.grey)),
              GestureDetector(onTap: (){
                setState(() {
                  IsFollowingSelected = false;
                });
              },child: Text("For you",style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: IsFollowingSelected ?14:18,color: IsFollowingSelected?Colors.grey:Colors.white))),
            ],
          ),
        ),
        body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection("UserPost").where('type',isEqualTo: "video").where('acctype',isEqualTo: "public").snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return PageView.builder(
                onPageChanged: (int page)=>{
                  setState((){
                    log(page.toString());
                    _snappedPageIndex = page;
                  })
                },
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoTile(video: snapshot.data!.docs[index]['posturl'],currentIndex: index,snappedPageIndex: _snappedPageIndex),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(flex: 3,
                              child: Container(
                                height: MediaQuery.of(context).size.height/4,
                                child: VideoDetails(username: snapshot.data!.docs[index]['username'],caption: snapshot.data!.docs[index]['caption'],UploaderUid: snapshot.data!.docs[index]['uid']),
                              )),
                          Expanded(child: Container(height: MediaQuery.of(context).size.height/1.75,
                            child: HomeSideBar(likes: snapshot.data!.docs[index]['likes'],profileUrl: snapshot.data!.docs[index]['profileurl'],PostId: snapshot.data!.docs[index]['postid'],UploaderUid: snapshot.data!.docs[index]['uid']),
                          ))
                        ],
                      )
                    ],
                  );
                },);
            }
            else{
              return Container(color: Colors.white,);
            }
          }
        )

      );
    } else {
      return Scaffold(
        body: Center(child: Text("here ui  is get pass or post id also")),
      );
    }
  }

}
