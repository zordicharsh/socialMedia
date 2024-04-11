import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../search_user/ui/searched_profile/anotherprofile.dart';


class VideoDetails extends StatefulWidget {
  VideoDetails(
      {super.key,
      required this.username,
      required this.caption,
      required this.UploaderUid,
      required this.profileUrl,
      required this.videoPlayingController,
      required this.isVideoPlaying});

  final String username;
  final String caption;
  final String UploaderUid;
  final String profileUrl;
  final CachedVideoPlayerController videoPlayingController;
  bool isVideoPlaying;

  @override
  State<VideoDetails> createState() => _VideoDetailsState();
}

class _VideoDetailsState extends State<VideoDetails> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
               //SizedBox(height: MediaQuery.of(context).size.height/8,),
              GestureDetector(
                onTap: () {
                  widget.videoPlayingController.pause();
                  setState(() {
                    widget.isVideoPlaying = false;
                  });
                  Navigator.push(
                      context,
                      CustomPageRouteRightToLeft(
                        child: AnotherUserProfile(
                            uid: widget.UploaderUid, username: widget.username),
                      )).then((value) {
                    widget.videoPlayingController.play();
                    setState(() {
                      widget.isVideoPlaying = true;
                    });
                  });
                },
                child: Row(
                  children: [
                    widget.profileUrl != ""
                        ? CachedNetworkImage(
                            imageUrl: widget.profileUrl,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 14.1.sp,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: imageProvider,
                                radius: 14.sp,
                              ),
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 14.1.sp,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey[900],
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
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      widget.username,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              widget.caption != ""
                  ? const SizedBox(
                      height: 8,
                    )
                  : const SizedBox.shrink(),

              widget.caption != ""
                  ? ReadMoreText(
                                widget.caption,
                                delimiter: '...',
                                preDataTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                                trimCollapsedText: 'View More',
                                trimExpandedText: '  View Less',
                                trimMode: TrimMode.Length,
                                trimLength:80,
                                moreStyle: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white60,
                                ),
                                lessStyle: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white60,
                                ),
                              ) /*ExpandableText(
                      widget.caption,
                      expandText: 'more',
                      collapseText: 'less',
                      expandOnTextTap: true,
                      collapseOnTextTap: true,
                      maxLines: 2,
                      linkColor: Colors.grey,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    )*/
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
