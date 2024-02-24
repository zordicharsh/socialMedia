import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {super.key,
      required this.currentImageIndex,
      required this.username,
      required this.profileimage, required this.likes, required this.caption, required this.uploadtime});

  final String currentImageIndex;
  final String username;
  final String profileimage;
  final String likes;
  final String caption;
  final Timestamp uploadtime;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  List randomImages = [
    "https://i.pinimg.com/474x/db/c7/63/dbc7636bb173ffb38acb503d8ee44995.jpg",
    "https://i.pinimg.com/474x/a7/e8/89/a7e889effe08ecbede2ddaafbecdbd66.jpg",
    "https://i.pinimg.com/236x/21/ea/de/21eade75b326b412dbff2aa320f571c8.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.keyboard_backspace))
            : null,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 32,
        ),
        backgroundColor: Colors.black,
        title: const Text(
          "Posts",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 4, right: 8, left: 12),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Row(
                    children: [
                      widget.profileimage != "" ?
                      CircleAvatar(
                        radius: 14.1,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                          NetworkImage(widget.profileimage),
                          radius: 14,
                        ),
                      ):
                      CircleAvatar(
                        radius: 14.1,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.black.withOpacity(0.8),
                          radius: 14,
                         child: Icon(Icons.person,color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        widget.username,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert_sharp),
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.45,
              width: double.infinity,
              child: ZoomOverlay(
                modalBarrierColor: Colors.black12,
// Optional
                minScale: 0.5,
// Optional
                maxScale: 3.0,
// Optional
                animationCurve: Curves.fastOutSlowIn,
// Defaults to fastOutSlowIn which mimics IOS instagram behavior
                animationDuration: const Duration(milliseconds: 300),
// Defaults to 100 Milliseconds. Recommended duration is 300 milliseconds for Curves.fastOutSlowIn
                twoTouchOnly: true,
// Defaults to false
                onScaleStart: () {},
// optional VoidCallback
                onScaleStop: () {},
// optional VoidCallback
                child: Image(
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    image: NetworkImage(
                      widget.currentImageIndex,
                    )),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.chat_bubble_outline_outlined,
                      ),
                      color: Colors.white,
                    ),
                    IconButton(
                      splashColor: Colors.black,
                      onPressed: () {},
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border),
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 0.0, bottom: 4, left: 16, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    for (int i = 0; i < randomImages.length; i++)
                      Align(
                        widthFactor: 0.59,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(randomImages[i]),
                          ),
                        ),
                      )
                  ],
                ),
                Row(
                  children: [
                    RichText(
                        text: const TextSpan(
                            style: TextStyle(color: Colors.white),
                            children: [
                          TextSpan(
                            text: "   Liked by",
                          ),
                          TextSpan(
                            text: " naman2811",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " and",
                          ),
                          TextSpan(
                            text: " 36 others",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]))
//   Text("Liked by naman2811 and 36 others")
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: widget.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:widget.caption,
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: GestureDetector(
              onTap: () {},
              child: const Text("View all 20 comments",
                  style: TextStyle(color: Colors.white60)),
            ),
          ),
           Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
            child: Text(DateFormat.d().add_yMMM().format(widget.uploadtime.toDate()),
                style: const TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }
}
