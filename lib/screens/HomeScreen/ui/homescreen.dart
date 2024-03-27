import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socialmedia/chat_screen/chat_user_lists/chatlist.dart';
import 'package:socialmedia/chat_screen/sharelist.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/follow_request_screen/followreuestscreen.dart';
import 'package:socialmedia/screens/profile/ui/widgets/comment.dart';
import 'package:socialmedia/screens/videocalling/alluserslist.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/home_side_bar.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/video_details.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/video_tile.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();

}
class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> followingList=[];
  @override
  void initState() {
    super.initState();
    getFollowingList();
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 2126705599,
      appSign: "707fa44ab5eaa519d60ebdb6a995d847c17108c877450576574c618ba3b680e2",
      userID: FirebaseAuth.instance.currentUser!.uid,
      userName: FirebaseAuth.instance.currentUser!.email.toString(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
  void getFollowingList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection("RegisteredUsers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // Access the "following" array from the document snapshot
      setState(() {
        followingList = snapshot.data()!['following'];
      });
    } catch (error) {
      log("Error fetching following list: $error");
    }
  }
  String value= "post";
  int _snappedPageIndex=0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              const Text('SocialRizz'),
              PopupMenuButton( icon: const Icon(Icons.arrow_drop_down),color: Colors.black,surfaceTintColor: Colors.black54,itemBuilder: (context) =>[
                const PopupMenuItem(value: "post",child: Text("Posts"),),
                const PopupMenuItem(value: "video",child: Text("Videos"),),
              ],onSelected: (newValue){
                setState(() {
                  value = newValue;
                });
              },)
            ],
          ),
          surfaceTintColor: Colors.black,
          actions: [
            IconButton(onPressed: (){
              Navigator.push(
                  context,
                  CustomPageRouteRightToLeft(
                    child: const Request(),
                  ));
            }, icon: const Icon(CupertinoIcons.bell)),
            Stack(
              children: [
                IconButton(onPressed: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AllUsersList(),));
                  Navigator.push(context,MaterialPageRoute(builder: (context) => ChatLists(),));
                }, icon: const Icon(CupertinoIcons.paperplane)),
                Positioned(
                  right: 9,
                  bottom: 2,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      "10",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],

            )
          ],
        ),
        body:Builder(builder: (context) {
          if(value == "post"){
            if(followingList.isEmpty){
              return const Center(child: Text("you are not following anyone"));
            }else{
              return RefreshIndicator(
                onRefresh: _onrefresh,
                child:StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("UserPost").where('uid',whereIn: followingList).where('type',isEqualTo: "image").orderBy("uploadtime",descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(child: CircularProgressIndicator());
                      }
                      if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data!.size, // Replace 10 with your actual item count
                          itemBuilder: (context, index) {
                            List likes = snapshot.data!.docs[index].data()["likes"];
                            log(index.toString());
                            if(snapshot.data!.docs[index].data()["type"]=="image"){
                              final islike = likes.contains(
                                  FirebaseAuth.instance.currentUser!.uid);
                              String formattedTime = DateFormat('dd-MM-yyyy').format(snapshot.data!.docs[index].data()["uploadtime"].toDate());
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:Colors.grey,
                                          radius: 18,
                                          backgroundImage: snapshot.data!.docs[index].data()["profileurl"] != ""
                                              ? NetworkImage(snapshot.data!.docs[index].data()["profileurl"])
                                              : null, // If profile URL is null, set backgroundImage to null
                                          child: snapshot.data!.docs[index].data()["profileurl"] == ""
                                              ? const Icon(Icons.account_circle,size: 36,) // Show an icon if profile URL is null
                                              : null, // If profile URL is not null, don't show any child
                                        ),

                                        const SizedBox(width: 8),
                                        Text(
                                          snapshot.data!.docs[index].data()["username"], // Replace with actual username
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          formattedTime,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ZoomOverlay(
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
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!.docs[index].data()["posturl"],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (islike) {
                                            DocumentReference currentUserRef =
                                            FirebaseFirestore.instance
                                                .collection('UserPost')
                                                .doc(snapshot.data!.docs[index].data()["postid"]);
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
                                                .doc(snapshot.data!.docs[index].data()["postid"]);
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
                                        icon: const Icon( CupertinoIcons.chat_bubble,),
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
                                                        postId: snapshot.data!.docs[index].data()["postid"],
                                                        scrollController: scrollController,
                                                        username: snapshot.data!.docs[index].data()["username"],
                                                        uidofpostuploader: snapshot.data!.docs[index].data()["uid"],
                                                      ));
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon( CupertinoIcons.paperplane,),
                                        onPressed: () {
                                          showModalBottomSheet(context: context, builder:(context) => ShareScreen(Postid:snapshot.data!.docs[index].data()["postid"],Type:snapshot.data!.docs[index].data()["type"]),);
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8,0,0,0),
                                        child: Text(
                                          "${likes.length} likes",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Builder(builder: (context) {
                                    if(snapshot.data!.docs[index].data()["caption"] == ""){
                                      return const SizedBox();
                                    }else{
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                        child: Row(
                                          children: [
                                            Text(
                                              snapshot.data!.docs[index].data()["caption"], // Replace with actual caption
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(8,0,0,0),
                                        child: GestureDetector(
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
                                                          postId: snapshot.data!.docs[index].data()["postid"],
                                                          scrollController: scrollController,
                                                          username: snapshot.data!.docs[index].data()["username"],
                                                          uidofpostuploader: snapshot.data!.docs[index].data()["uid"],
                                                        ));
                                              },
                                            );
                                          },
                                          child: Text(
                                            "view ${snapshot.data!.docs[index].data()["totalcomments"].toString()} comment",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              );
                            }else{
                              return const SizedBox();
                            }


                          },
                        );
                      }
                      else{
                        return const SizedBox();
                      }
                    }
                ),
              );
            }
          }else {
            if (followingList.isEmpty) {
              return const Center(child: Text("you are not following anyone"));
            }else{
              return StreamBuilder(
                stream: FirebaseFirestore.instance.collection("UserPost").where(
                    'uid', whereIn: followingList).where(
                    'type', isEqualTo: "video").orderBy(
                    "uploadtime", descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> filteredList = [];

                    snapshot.data!.docs.forEach((doc) {
                      filteredList.add(doc);
                    });
                    // Concatenate the filtered list with other videos
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
                                  child: SizedBox(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height / 4,
                                    child: VideoDetails(
                                      username: filteredList[index]['username'],
                                      caption: filteredList[index]['caption'],
                                      UploaderUid: filteredList[index]['uid'],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height / 1.75,
                                    child: HomeSideBar(
                                      likes: filteredList[index]['likes'],
                                      profileUrl: filteredList[index]['profileurl'],
                                      PostId: filteredList[index]['postid'],
                                      UploaderUid: filteredList[index]['uid'],
                                      username: filteredList[index]['username'],
                                      noofcomments: filteredList[index]['totalcomments'],
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
              );
            }

          }
        },)

    );
  }

  Future<void> _onrefresh() {
    setState(() {
    });
    return Future.delayed(const Duration(seconds: 2));
  }
}