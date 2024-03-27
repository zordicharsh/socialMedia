import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String touid;

  const ChatScreen({required this.touid, Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DocumentSnapshot<Map<String, dynamic>>? userDataSnapshot;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  void getUserDetail() async {
    userDataSnapshot = await FirebaseFirestore.instance
        .collection("RegisteredUsers")
        .doc(widget.touid)
        .get();
    setState(() {}); // Update the UI after getting user details
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("RegisteredUsers")
          .doc(widget.touid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                ZegoSendCallInvitationButton(
                  iconSize: Size(40, 40),
                  buttonSize: Size(40, 40),
                  isVideoCall: false,
                  resourceID:
                  "zego_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                  invitees: [
                    ZegoUIKitUser(
                      id: snapshot.data!.get('uid'),
                      name: snapshot.data!.get('username').toString(),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                ZegoSendCallInvitationButton(
                  iconSize: Size(40, 40),
                  buttonSize: Size(40, 40),
                  isVideoCall: true,
                  resourceID:
                  "zego_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                  invitees: [
                    ZegoUIKitUser(
                      id: snapshot.data!.get('uid'),
                      name: snapshot.data!.get('username').toString(),
                    ),
                  ],
                )
              ],
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                    NetworkImage(snapshot.data!.get('profileurl')),
                  ),
                  SizedBox(width: 8),
                  Text(
                    snapshot.data!.get('username'),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              backgroundColor: Colors.black,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Chats')
                        .where('senderuid',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('receiveruid', isEqualTo: widget.touid)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, senderSnapshot) {
                      if (senderSnapshot.hasData) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Chats')
                              .where('senderuid', isEqualTo: widget.touid)
                              .where('receiveruid', isEqualTo:
                          FirebaseAuth.instance.currentUser!.uid)
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, receiverSnapshot) {
                            if (receiverSnapshot.hasData) {
                              List<QueryDocumentSnapshot> combinedSnapshots =
                                  senderSnapshot.data!.docs +
                                      receiverSnapshot.data!.docs;
                              combinedSnapshots.sort((a, b) => b['timestamp']
                                  .compareTo(
                                  a['timestamp'])); // Sort by timestamp
                              return ListView.builder(
                                reverse: true,
                                itemCount: combinedSnapshots.length,
                                itemBuilder: (context, index) {
                                  var message =
                                  combinedSnapshots[index].data() as Map;
                                  bool isCurrentUser = message['senderuid'] ==
                                      FirebaseAuth.instance.currentUser!.uid;
                                  bool isSeen = message['seen'] ?? false;
                                  if (!isSeen && !isCurrentUser) {
                                    // Mark the message as seen if it's not from the current user and hasn't been seen yet
                                    markMessageAsSeen(
                                        combinedSnapshots[index].id);
                                  }
                                  DateTime timestamp =
                                  (message['timestamp'] as Timestamp)
                                      .toDate();
                                  String formattedTime =
                                  DateFormat('hh:mm').format(timestamp);
                                  return Align(
                                    alignment: isCurrentUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: isCurrentUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isCurrentUser
                                                ? Colors.blue
                                                : Colors.green,
                                            borderRadius:
                                            BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              if (message
                                                  .containsKey('message'))
                                                Text(
                                                  message['message'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              if (message.containsKey('image'))
                                                Image.network(
                                                  message['image'],
                                                  width: 200,
                                                  height: 300,
                                                  fit: BoxFit.fill,
                                                ),
                                              if(message.containsKey('postid'))
                                                StreamBuilder(
                                                  stream: FirebaseFirestore.instance.collection('UserPost').doc(message['postid']).snapshots(),
                                                  builder: (context, postSnapshot) {
                                                    if(postSnapshot.connectionState == ConnectionState.waiting){
                                                      return CircularProgressIndicator();
                                                    }
                                                    else if(postSnapshot.data!.exists){
                                                      if (postSnapshot.hasData) {
                                                        if(postSnapshot.data!.get('type')=="image"){
                                                          return Container(
                                                            child: Image.network(postSnapshot.data!.get('posturl'),
                                                              width: 200,
                                                              height: 300,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            // Other UI components to display the post data
                                                          );
                                                        }
                                                        else{
                                                          return Container(
                                                            child: Image.network(postSnapshot.data!.get('thumbnail'),
                                                              width: 200,
                                                              height: 300,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            // Other UI components to display the post data
                                                          );
                                                        }
                                                      }
                                                      else if(postSnapshot.hasData==false){
                                                        return Text('Post not found');
                                                      }
                                                      else {
                                                        return Text('Post not found');
                                                      }
                                                    }else{
                                                      return Text('Post not found');
                                                    }
                                                  },
                                                )
                                            ],
                                          ),
                                        ),
                                        if (isCurrentUser)
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                    formattedTime), // Displaying formatted time
                                                Icon(
                                                  isSeen
                                                      ? Icons.done_all_rounded
                                                      : Icons.done_rounded,
                                                  color: isSeen
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  size: 18,
                                                ),
                                              ],
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                            ),
                                          )
                                        else
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                    formattedTime), // Displaying formatted time
                                              ],
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          _pickImage();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          sendMessage();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void sendMessage({String? imageUrl}) {
    String message = _messageController.text.trim();
    if (message.isNotEmpty || imageUrl != null) {
      Map<String, dynamic> messageData = {
        'receiveruid': widget.touid,
        'senderuid': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': Timestamp.now(),
        'seen': false,
      };

      if (imageUrl != null) {
        messageData['image'] = imageUrl;
      } else {
        messageData['message'] = message;
      }

      FirebaseFirestore.instance
          .collection('Chats')
          .add(messageData)
          .then((value) {
        _messageController.clear();
      }).catchError((error) {
        print("Failed to send message: $error");
      });
    }
  }

  void markMessageAsSeen(String messageId) {
    FirebaseFirestore.instance.collection('Chats').doc(messageId).update({
      'seen': true,
    }).catchError((error) {
      print("Failed to mark message as seen: $error");
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Upload image to Firebase Storage
      File imageFile = File(pickedFile.path);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref =
      FirebaseStorage.instance.ref().child('chat_images').child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Get the image URL
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Send the message with the image URL
      sendMessage(imageUrl: imageUrl);
    }
  }
}