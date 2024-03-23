import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AllUsersList extends StatefulWidget {
  const AllUsersList({super.key});

  @override
  State<AllUsersList> createState() => _AllUsersListState();
}

class _AllUsersListState extends State<AllUsersList> {
  List<dynamic> followingList=[];
  @override
  void initState() {
    super.initState();
    getFollowingList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemCount: followingList.length,itemBuilder: (context, index) {
        return ListTile(
         leading: Text(followingList[index]),
          trailing: Container(
            child: ZegoSendCallInvitationButton(
              iconSize: Size(40, 40),
              isVideoCall: true,
              resourceID: "zego_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
              invitees: [
                ZegoUIKitUser(
                  id: followingList[index],
                  name: followingList[index].toString(),
                ),
              ],
            ),
          ),
        );
      },),
    );
  }
}
