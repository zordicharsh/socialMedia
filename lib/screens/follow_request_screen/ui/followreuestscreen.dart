// screenn

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/screens/follow_request_screen/bloc/request_bloc.dart';
import 'package:socialmedia/screens/follow_request_screen/bloc/request_event.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  var UID;

  @override
  void initState() {
    UID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("RegisteredUsers")
            .doc(UID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            List follower = snapshot.data!.get('followrequestnotification');
            if (follower.isNotEmpty) {
              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("RegisteredUsers")
                    .where("uid", whereIn: follower)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        var FollowUserUid = snapshot.data!.docs[index]['uid'];
                        var imagess = snapshot.data!.docs[index]['profileurl'];
                        return ListTile(
                          leading: imagess != ""
                              ? CachedNetworkImage(
                                  imageUrl: imagess,
                                  placeholder: (context, url) => CircleAvatar(
                                    backgroundColor: Colors.grey.withOpacity(0.3),
                                    radius: 20.sp,
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                          radius: 20.sp,
                                          backgroundImage: imageProvider),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.3),
                                  radius: 20.sp,
                                ),
                          title: Text(
                            "${snapshot.data!.docs[index]['username']} requested to follow you",
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<RequestBloc>(context).add(
                                      AcceptFollowRequestEvent(
                                          FollowUserUid, UID));
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(32.sp, 28),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  BlocProvider.of<RequestBloc>(context).add(
                                      DeleteFollowRequestEvent(
                                          FollowUserUid, UID));
                                },
                                icon: const Icon(CupertinoIcons.clear),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("No Request"),
                    );
                  } else if (snapshot.hasData == false) {
                    return const Center(
                      child: Text("No Request"),
                    );
                  }
                  return Container();
                },
              );
            } else {
              return const Center(
                child: Text("No Request"),
              );
            }
          } else if (snapshot.hasData == false) {
            return const Center(
              child: Text("No Request"),
            );
          }
          return Container();
        },
      ),
    );
  }
}
