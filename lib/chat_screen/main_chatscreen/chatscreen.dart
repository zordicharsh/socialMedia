import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

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
                  buttonSize: Size(40,40),
                  isVideoCall: false,
                  resourceID: "zego_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                  invitees: [
                    ZegoUIKitUser(
                      id: snapshot.data!.get('uid'),
                      name: snapshot.data!.get('username').toString(),
                    ),
                  ],
                ),
                SizedBox(width: 20,),
                ZegoSendCallInvitationButton(
                  iconSize: Size(40, 40),
                  buttonSize: Size(40,40),
                  isVideoCall: true,
                  resourceID: "zego_call", //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
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
                        .where('senderuid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .where('receiveruid', isEqualTo: widget.touid)
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, senderSnapshot) {
                      if (senderSnapshot.hasData) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Chats')
                              .where('senderuid', isEqualTo: widget.touid)
                              .where('receiveruid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, receiverSnapshot) {
                            if (receiverSnapshot.hasData) {
                              List<QueryDocumentSnapshot> combinedSnapshots =
                                  senderSnapshot.data!.docs + receiverSnapshot.data!.docs;
                              combinedSnapshots.sort((a, b) => b['timestamp'].compareTo(a['timestamp'])); // Sort by timestamp
                              return ListView.builder(
                                reverse: true,
                                itemCount: combinedSnapshots.length,
                                itemBuilder: (context, index) {
                                  var message = combinedSnapshots[index].data() as Map;
                                  bool isCurrentUser = message['senderuid'] == FirebaseAuth.instance.currentUser!.uid;
                                  bool isSeen = message['seen'] ?? false;
                                  if (!isSeen && !isCurrentUser) {
                                    // Mark the message as seen if it's not from the current user and hasn't been seen yet
                                    markMessageAsSeen(combinedSnapshots[index].id);
                                  }
                                  return Align(
                                    alignment: isCurrentUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isCurrentUser
                                            ? Colors.blue
                                            : Colors.green,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message['message'],
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          if (isCurrentUser)
                                            Text(
                                              isSeen ? 'Seen' : 'Sent',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                        ],
                                      ),
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

  void sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      FirebaseFirestore.instance.collection('Chats').add({
        'receiveruid': widget.touid,
        'message': message,
        'senderuid': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': Timestamp.now(),
        'seen': false, // Mark the message as unseen initially
      }).then((value) {
        // Clear the message input field after sending
        _messageController.clear();
      }).catchError((error) {
        // Handle error
        print("Failed to send message: $error");
      });
    }
  }

  void markMessageAsSeen(String messageId) {
    FirebaseFirestore.instance.collection('Chats').doc(messageId).update({
      'seen': true,
    }).catchError((error) {
      // Handle error
      print("Failed to mark message as seen: $error");
    });}
}