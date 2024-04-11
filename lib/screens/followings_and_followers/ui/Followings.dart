import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../search_user/ui/searched_profile/anotherprofile.dart';
import '../bloc/followers_following_bloc.dart';
import '../bloc/followers_following_event.dart';
class Following extends StatefulWidget {
String? UID;

Following(this.UID);

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  String? CurrentUser = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    if(CurrentUser == widget.UID){
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text("Following"),scrolledUnderElevation: 0,),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("RegisteredUsers").doc(widget.UID).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasData) {
              List follower = snapshot.data!.get('following');
              if(follower.isNotEmpty){
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("RegisteredUsers").where("uid",whereIn:follower).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child:
                        CircularProgressIndicator(),
                      );
                    }
                   else if (snapshot.hasData) {
                      return ListView.separated(
                        itemCount:snapshot.data!.size,
                        itemBuilder: (context, index) {
                          var FollowUserUid = snapshot.data!.docs[index]['uid'];
                          var imagess = snapshot.data!.docs[index]['profileurl'];
                          return ListTile(
                            splashColor: Colors.grey[900],
                            onTap: () => Navigator.push(context, CustomPageRouteRightToLeft(child: AnotherUserProfile(uid: snapshot.data!.docs[index]['uid'], username: snapshot.data!.docs[index]['username']),)),
                            leading: imagess != ""
                                ? CachedNetworkImage(
                              imageUrl:
                              imagess,
                              imageBuilder: (context,
                                  imageProvider) =>
                                  CircleAvatar(
                                    radius: 20.1.sp,
                                    backgroundColor:
                                    Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor:
                                      Colors.grey,
                                      backgroundImage:
                                      imageProvider,
                                      radius: 20.sp,
                                    ),
                                  ),
                              placeholder:
                                  (context, url) =>
                                  CircleAvatar(
                                    radius: 20.1.sp,
                                    backgroundColor:
                                    Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor:
                                      Colors.grey[900],
                                      radius: 20.sp,
                                    ),
                                  ),
                            )
                                : CircleAvatar(
                              radius: 20.1.sp,
                              backgroundColor:
                              Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors
                                    .black
                                    .withOpacity(0.8),
                                radius: 20.sp,
                                child: Icon(Icons.person,
                                  color: Colors.black
                                      .withOpacity(
                                      0.5),size: 36,),
                              ),
                            ),
                            title: Text(snapshot.data!.docs[index]['username'],
                                style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                            subtitle:Text(snapshot.data!.docs[index]['name'],
                                style: const TextStyle(fontSize: 12,color: Colors.white54)),
                            trailing:  ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<FollowingFollowerBloc>(context).add(DeleteFollowerFollowingEvent2(FollowUserUid,widget.UID.toString()));
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(28.sp,28.sp),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('Remove',style: TextStyle(color: Colors.white),),
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) => SizedBox(height: 8,),
                      );
                    }
                    else if(snapshot.hasError){
                      return const Center(
                        child:  Text("No Followers"),
                      );
                    }
                    else if(snapshot.hasData == false ){
                      return const Center(
                        child:  Text("No Followers"),
                      );
                    }
                    return Container();
                  },
                );
              }
              else{
                return const Center(
                  child: Text("No Followers"),
                );
              }
            }
            else if(snapshot.hasData == false ) {
              return const Center(
                child: Text("No Followers"),
              );
            }
            return Container();
          },
        ),
      );
    }else
      {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(title: const Text("Following"),scrolledUnderElevation: 0,),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("RegisteredUsers").doc(widget.UID).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }
             else if (snapshot.hasData) {
                List follower = snapshot.data!.get('following');
                if(follower.isNotEmpty){
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("RegisteredUsers").where("uid",whereIn:follower).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting)
                        {
                          return const Center(
                            child:
                            CircularProgressIndicator(),
                          );
                        }
                     else if (snapshot.hasData) {
                        return ListView.separated(
                          itemCount:snapshot.data!.size,
                          itemBuilder: (context, index) {
                            var imagess = snapshot.data!.docs[index]['profileurl'];
                            return ListTile(
                              splashColor: Colors.grey[900],
                              onTap: () => Navigator.push(context, CustomPageRouteRightToLeft(child: AnotherUserProfile(uid: snapshot.data!.docs[index]['uid'], username: snapshot.data!.docs[index]['username']),)),
                              leading: imagess != ""
                                  ? CachedNetworkImage(
                                imageUrl:
                                imagess,
                                imageBuilder: (context,
                                    imageProvider) =>
                                    CircleAvatar(
                                      radius: 20.1.sp,
                                      backgroundColor:
                                      Colors.white,
                                      child: CircleAvatar(
                                        backgroundColor:
                                        Colors.grey,
                                        backgroundImage:
                                        imageProvider,
                                        radius: 20.sp,
                                      ),
                                    ),
                                placeholder:
                                    (context, url) =>
                                    CircleAvatar(
                                      radius: 20.1.sp,
                                      backgroundColor:
                                      Colors.white,
                                      child: CircleAvatar(
                                        backgroundColor:
                                        Colors.grey[900],
                                        radius: 20.sp,
                                      ),
                                    ),
                              )
                                  : CircleAvatar(
                                radius: 20.1.sp,
                                backgroundColor:
                                Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Colors
                                      .black
                                      .withOpacity(0.8),
                                  radius: 20.sp,
                                  child: Icon(Icons.person,
                                    color: Colors.black
                                        .withOpacity(
                                        0.5),size: 36,),
                                ),
                              ),
                              title: Text(snapshot.data!.docs[index]['username'],
                                  style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                              subtitle:Text(snapshot.data!.docs[index]['name'],
                                  style: const TextStyle(fontSize: 12,color: Colors.white54)),
                            );
                          }, separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8,),
                        );
                      }
                      else if(snapshot.hasError){
                        return const Center(
                          child:  Text("No Followers"),
                        );
                      }
                      else if(snapshot.hasData == false ){
                        return const Center(
                          child:  Text("No Followers"),
                        );
                      }
                      return Container();
                    },
                  );
                }
                else{
                  return const Center(
                    child: Text("No Followers"),
                  );
                }
              }
              else if(snapshot.hasData == false ) {
                return const Center(
                  child: Text("No Followers"),
                );
              }
              return Container();
            },
          ),
        );
      }

  }
}
