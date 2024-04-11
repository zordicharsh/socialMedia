import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/chat_screen/main_chatscreen/shared_post_page.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../search_user/ui/searched_profile/anotherprofile.dart';

class ChatScreen extends StatefulWidget {
  final String touid;

  const ChatScreen({required this.touid, Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DocumentSnapshot<Map<String, dynamic>>? userDataSnapshot;
  TextEditingController messageController = TextEditingController();

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
            backgroundColor: Colors.black,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              actions: [
                ZegoSendCallInvitationButton(
                  iconSize: Size(32.sp, 32.sp),
                  buttonSize: Size(32.sp, 32.sp),
                  notificationTitle: snapshot.data!.get('name'),
                  notificationMessage:
                      "hi! Voice call from ${snapshot.data!.get('name')}",
                  isVideoCall: false,
                  resourceID: "zego_call",
                  //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                  invitees: [
                    ZegoUIKitUser(
                      id: snapshot.data!.get('uid'),
                      name: snapshot.data!.get('username').toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0.sp),
                  child: ZegoSendCallInvitationButton(
                    iconSize: Size(32.sp, 32.sp),
                    buttonSize: Size(32.sp, 32.sp),
                    notificationTitle: snapshot.data!.get('name'),
                    notificationMessage:
                        "hi! Video call from ${snapshot.data!.get('name')}",
                    isVideoCall: true,
                    resourceID: "zego_call",
                    //You need to use the resourceID that you created in the subsequent steps. Please continue reading this document.
                    invitees: [
                      ZegoUIKitUser(
                        id: snapshot.data!.get('uid'),
                        name: snapshot.data!.get('username').toString(),
                      ),
                    ],
                  ),
                )
              ],
              title: Row(
                children: [
                  snapshot.data!.get('profileurl') != ""
                      ? CachedNetworkImage(
                          imageUrl: snapshot.data!.get('profileurl'),
                          filterQuality: FilterQuality.low,
                          placeholder: (context, url) => CircleAvatar(
                            radius: 14.1.sp,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.3),
                              radius: 14.sp,
                            ),
                          ),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 14.1.sp,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.4),
                              backgroundImage: imageProvider,
                              radius: 14.sp,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 14.1.sp,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.8),
                            radius: 14.sp,
                            child: Icon(Icons.person,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.get('name'),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        snapshot.data!.get('username'),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                    ],
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
                              .where('receiveruid',
                                  isEqualTo:
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
                              combinedSnapshots =
                                  combinedSnapshots.reversed.toList();
                              return StickyGroupedListView(
                                reverse: true,
                                elements: combinedSnapshots,
                                order: StickyGroupedListOrder.DESC,
                                groupBy: (element) {
                                  // Group by timestamp
                                  DateTime timestamp =
                                      (element['timestamp'] as Timestamp)
                                          .toDate();
                                  return DateTime(
                                    timestamp.year,
                                    timestamp.month,
                                    timestamp.day,
                                  );
                                },
                                stickyHeaderBackgroundColor: Colors.transparent,
                                groupSeparatorBuilder:
                                    (QueryDocumentSnapshot element) {
                                  DateTime timestamp =
                                      (element['timestamp'] as Timestamp)
                                          .toDate();
                                  return Container(
                                    height: 36,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 160),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Center(
                                      child: Text(
                                        DateFormat('MMMMd')
                                                    .format(DateTime.now()) ==
                                                DateFormat('MMMMd')
                                                    .format(timestamp)
                                            ? "Today"
                                            : DateFormat('MMMMd').format(
                                                        DateTime.now().subtract(
                                                            const Duration(
                                                                days: 1))) ==
                                                    DateFormat('MMMMd')
                                                        .format(timestamp)
                                                ? "Yesterday"
                                                : DateFormat('MMMMd')
                                                    .format(timestamp),
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                  );
                                },
                                floatingHeader: false,
                                itemBuilder: (context, index) {
                                  var message = index.data() as Map;
                                  bool isCurrentUser = message['senderuid'] ==
                                      FirebaseAuth.instance.currentUser!.uid;
                                  bool isSeen = message['seen'] ?? false;
                                  if (!isSeen && !isCurrentUser) {
                                    // Mark the message as seen if it's not from the current user and hasn't been seen yet
                                    markMessageAsSeen(index.id);
                                  }
                                  DateTime timestamp =
                                      (message['timestamp'] as Timestamp)
                                          .toDate();
                                  String formattedTime =
                                      DateFormat('hh:mm aa').format(timestamp);
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
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          padding:
                                              message.containsKey('message')
                                                  ? const EdgeInsets.all(10)
                                                  : EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: isCurrentUser
                                                ? message.containsKey('message')
                                                    ? Colors.blue
                                                    : Colors.white
                                                        .withOpacity(0.1)
                                                : message.containsKey('message')
                                                    ? Colors.grey[900]
                                                    : Colors.white
                                                        .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (message.containsKey('message'))
                                                Text(
                                                  message['message'],
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )

                                              else if (message.containsKey('image'))
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: message['image'],
                                                    width: 200,
                                                    height: 280,
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.low,
                                                  ),
                                                )

                                              else if (message.containsKey('postid'))
                                                FutureBuilder(
                                                  future: FirebaseFirestore
                                                      .instance
                                                      .collection('UserPost')
                                                      .doc(message['postid'])
                                                      .get(),
                                                  builder:
                                                      (context, postSnapshot) {
                                                    if (postSnapshot.hasError) {
                                                      return const Text(
                                                          'error');
                                                    }
                                                    else if (postSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(16.0),
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              Navigator.push(
                                                                  context,
                                                                  CustomPageRouteRightToLeft(
                                                                      child:
                                                                      SharedPostInChatItemState(
                                                                        postdata:
                                                                        postSnapshot,
                                                                      ))),
                                                          child: Column(
                                                            mainAxisSize:
                                                            MainAxisSize
                                                                .min,
                                                            children: [
                                                              Container(
                                                              width: 300,
                                                              color: Colors.grey[900],
                                                              child: ListTile(
                                                                leading:
                                                                   CircleAvatar(
                                                                  radius: 14.1,
                                                                  backgroundColor: Colors.white,
                                                                  child: CircleAvatar(
                                                                    backgroundColor: Colors.black.withOpacity(0.8),
                                                                    radius: 14,
                                                                    child:
                                                                    Icon(Icons.person, color: Colors.black.withOpacity(0.5)),
                                                                  ),
                                                                ),
                                                                title: const Text(
                                                                  "",
                                                                  style:
                                                                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                ),
                                                              )),


                                                              Stack(
                                                                alignment:
                                                                Alignment
                                                                    .topRight,
                                                                children: [
                                                                 Container(
                                                                    width: 300,
                                                                    height: 300,

                                                                  ),
                                                                ],
                                                              ),

                                                              Container(
                                                                width: 300,
                                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                                                color: Colors.grey[900],
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "",
                                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 6,
                                                                    ),
                                                                    SizedBox(
                                                                        width: 180.sp,
                                                                        child: Text("",
                                                                            style: const TextStyle(
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ))),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ) ;
                                                    }

                                                     else if (!postSnapshot.data!.exists) {
                                                      return Container(
                                                        width: 228.sp,
                                                        height: 84,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12,
                                                                horizontal: 12),
                                                        child: const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            Text(
                                                              'Post Unavailable',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Text(
                                                              'This post is unavailable because it was deleted.',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .white38),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    else {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              Navigator.push(
                                                                  context,
                                                                  CustomPageRouteRightToLeft(
                                                                      child:
                                                                          SharedPostInChatItemState(
                                                                    postdata:
                                                                        postSnapshot,
                                                                  ))),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              _createPhotoTitle(
                                                                  postSnapshot
                                                                      .data!
                                                                      .get(
                                                                          'profileurl'),
                                                                  postSnapshot
                                                                      .data!
                                                                      .get(
                                                                          'username')),
                                                              Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                children: [
                                                                  CachedNetworkImage(
                                                                    imageUrl: postSnapshot.data!.get('type') ==
                                                                            "image"
                                                                        ? postSnapshot
                                                                            .data!
                                                                            .get(
                                                                                'posturl')
                                                                        : postSnapshot
                                                                            .data!
                                                                            .get('thumbnail'),
                                                                    width: 300,
                                                                    height: 300,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  postSnapshot.data!.get(
                                                                              'type') ==
                                                                          "image"
                                                                      ? const SizedBox
                                                                          .shrink()
                                                                      : const Padding(
                                                                          padding:
                                                                              EdgeInsets.all(2.0),
                                                                          child: Icon(
                                                                              Icons.video_library,
                                                                              size: 20),
                                                                        )
                                                                ],
                                                              ),
                                                              _createCaptionBar(
                                                                  postSnapshot
                                                                      .data!
                                                                      .get(
                                                                          'username'),
                                                                  postSnapshot
                                                                      .data!
                                                                      .get(
                                                                          'caption'))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                )

                                              else if(message.containsKey('profileid'))
                                                GestureDetector(
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    CustomPageRouteRightToLeft(
                                                      child: AnotherUserProfile(
                                                          uid: message['profileid'],
                                                          username:message['username']),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: 228.sp,
                                                    height: 64,
                                                    color:Colors.transparent,
                                                    padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        message['profileurl'] != ""
                                                            ? CachedNetworkImage(
                                                          imageUrl:message['profileurl'],
                                                          imageBuilder: (context, imageProvider) =>
                                                              CircleAvatar(
                                                                radius: 18.1.sp,
                                                                backgroundColor: Colors.white,
                                                                child: CircleAvatar(
                                                                  backgroundColor: Colors.grey,
                                                                  backgroundImage: imageProvider,
                                                                  radius: 18.sp,
                                                                ),
                                                              ),
                                                          placeholder: (context, url) => CircleAvatar(
                                                            radius: 18.1.sp,
                                                            backgroundColor: Colors.white,
                                                            child: CircleAvatar(
                                                              backgroundColor: Colors.grey[900],
                                                              radius: 18.sp,
                                                            ),
                                                          ),
                                                        )
                                                            : CircleAvatar(
                                                          radius: 14.1.sp,
                                                          backgroundColor: Colors.white,
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors.black.withOpacity(0.8),
                                                            radius: 14.sp,
                                                            child: Icon(Icons.person,
                                                                color: Colors.black.withOpacity(0.5)),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              message['username'],
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                            Text(
                                                              message['name'],
                                                              style: const TextStyle(
                                                                  color: Colors.white54,
                                                                fontSize: 10
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )

                                              else
                                                const SizedBox.shrink()
                                            ],
                                          ),
                                        ),
                                        if (isCurrentUser)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  formattedTime,
                                                  style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 11),
                                                ),
                                                // Displaying formatted time
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  isSeen
                                                      ? Icons.done_all_rounded
                                                      : Icons.done_all_rounded,
                                                  color: isSeen
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          )
                                        else
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(formattedTime,
                                                    style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 11,
                                                    )),
                                                // Displaying formatted time
                                              ],
                                            ),
                                          ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey[900],
                                ),
                              );
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey[900],
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        controller: messageController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: " Message... ",
                          contentPadding:
                              EdgeInsets.only(right: 92.sp, left: 16.sp),
                          filled: true,
                          fillColor: Colors.grey[900],
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 56,
                        child: Container(
                          width: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: Center(
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                CupertinoIcons.photo,
                                size: 20,
                              ),
                              onPressed: () {
                                _pickImage();
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => sendMessage(),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const SweepGradient(colors: [
                                      Colors.pinkAccent,
                                      Colors.pinkAccent,
                                      Colors.orangeAccent,
                                      Colors.red,
                                      Colors.purple,
                                      Colors.pink,
                                    ])),
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey[900]),
                              ),
                              const Icon(
                                Icons.arrow_upward_sharp,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            /* appBar: AppBar(
              title: const Text('Loading...'),
            ),*/
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  void sendMessage({String? imageUrl}) {
    String message = messageController.text.trim();
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
        messageController.clear();
      }).catchError((error) {
        log("Failed to send message: $error");
      });
    }
  }

  void markMessageAsSeen(String messageId) {
    FirebaseFirestore.instance.collection('Chats').doc(messageId).update({
      'seen': true,
    }).catchError((error) {
      log("Failed to mark message as seen: $error");
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

  Widget _createPhotoTitle(String profileurl, String username) => Container(
      width: 300,
      color: Colors.grey[900],
      child: ListTile(
        leading: profileurl != ""
            ? CircleAvatar(
                radius: 14.1,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(profileurl),
                  radius: 14,
                ),
              )
            : CircleAvatar(
                radius: 14.1,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.8),
                  radius: 14,
                  child:
                      Icon(Icons.person, color: Colors.black.withOpacity(0.5)),
                ),
              ),
        title: Text(
          username,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ));

  Widget _createCaptionBar(String username, String caption) => Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 6,
            ),
            SizedBox(
                width: 180.sp,
                child: Text(caption,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ))),
          ],
        ),
      );
}
