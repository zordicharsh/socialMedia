import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class VideoDetails extends StatelessWidget {
  const VideoDetails({super.key, required this.username,required this.caption, required this.UploaderUid});
final String username;
final String caption;
final String UploaderUid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "@${username}",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          ExpandableText(
            caption,
            expandText: 'more',
            collapseText: 'less',
            expandOnTextTap: true,
            collapseOnTextTap: true,
            maxLines: 2,
            linkColor: Colors.grey,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}



