import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchedProfileTagSection extends StatefulWidget {
  const SearchedProfileTagSection({super.key});

  @override
  State<SearchedProfileTagSection> createState() => _SearchedProfileTagSectionState();
}

class _SearchedProfileTagSectionState extends State<SearchedProfileTagSection> {
  @override
  Widget build(BuildContext context) {
    return  const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 42,
              child: Icon(
                CupertinoIcons.person_crop_square,
                size: 38,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "No posts yet",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
