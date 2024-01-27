import 'package:flutter/material.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.currentImageIndex});

  final String currentImageIndex;

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
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 14.3,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              AssetImage("assets/images/cat_pic.jpg"),
                          radius: 14,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "lilstuart",
                        style: TextStyle(
                            color: Colors.white,),
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
              height: MediaQuery.sizeOf(context).height * 0.4,
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
                      icon: const Icon(Icons.messenger_outline_outlined),
                      color: Colors.white,
                    ),
                    IconButton(
                      splashColor: Colors.black,
                      onPressed: () {},
                      icon: const Icon(Icons.send_outlined),
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
              text: const TextSpan(
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: "lilstuart",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: "  This Text Showcases The Caption For Given Pic.",
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
            child: Text("26 January 2024",
                style: TextStyle(color: Colors.white60)),
          ),
        ],
      ),
    );
  }
}
