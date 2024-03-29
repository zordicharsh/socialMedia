import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../search_user/searchui/searched_profile/anotherprofile.dart';

class VideoDetails extends StatelessWidget {
  const VideoDetails(
      {super.key,
      required this.username,
      required this.caption,
      required this.UploaderUid,
      required this.profileUrl});

  final String username;
  final String caption;
  final String UploaderUid;
  final String profileUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              profileUrl != ""
                  ? CachedNetworkImage(
                      imageUrl: profileUrl,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 14.1.sp,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
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
              const SizedBox(
                width: 12,
              ),
              Text(
                username,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          caption != ""
              ? const SizedBox(
                  height: 8,
                )
              : const SizedBox.shrink(),
          caption != ""
              ? ExpandableText(
                  caption,
                  expandText: 'more',
                  collapseText: 'less',
                  expandOnTextTap: true,
                  collapseOnTextTap: true,
                  maxLines: 2,
                  linkColor: Colors.grey,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
