import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/screens/FollowingsAndFollowers/followers_following_event.dart';

import 'followers_following_bloc.dart';
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
        appBar: AppBar(title: const Text("Following"),),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("RegisteredUsers").doc(widget.UID).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List follower = snapshot.data!.get('following');
              if(follower.isNotEmpty){
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("RegisteredUsers").where("uid",whereIn:follower).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount:snapshot.data!.size,
                        itemBuilder: (context, index) {
                          var FollowUserUid = snapshot.data!.docs[index]['uid'];
                          var imagess = snapshot.data!.docs[index]['profileurl'];
                          return ListTile(
                            leading: CircleAvatar(
                                radius: 20,
                                backgroundImage :imagess != null ?
                                NetworkImage(imagess) : null),
                            title: Text( snapshot.data!.docs[index]['username'], style: const TextStyle(fontSize:15),),
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
                        },
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
          appBar: AppBar(title: const Text("Following"),),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("RegisteredUsers").doc(widget.UID).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List follower = snapshot.data!.get('following');
                if(follower.isNotEmpty){
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("RegisteredUsers").where("uid",whereIn:follower).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount:snapshot.data!.size,
                          itemBuilder: (context, index) {
                            var FollowUserUid = snapshot.data!.docs[index]['uid'];
                            var imagess = snapshot.data!.docs[index]['profileurl'];
                            return ListTile(
                              leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage :imagess != null ?
                                  NetworkImage(imagess) : null),
                              title: Text( snapshot.data!.docs[index]['username'], style: const TextStyle(fontSize:15),),
                            );
                          },
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
