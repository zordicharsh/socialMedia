import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../common_widgets/single_item_state/single(post_card)state.dart';
import '../../../../common_widgets/single_item_state/single(video_post_card)state.dart';
import '../../bloc/profile_bloc.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {super.key,
      required this.currentImageIndex, required this.uid,});

final int currentImageIndex;
final String uid;
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
@override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(ProfilePageFetchUserPostEvent(userid: widget.uid));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
      body: BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    if(state is ProfilePageFetchUserPostSuccessState) {
            return StreamBuilder(
              stream: state.postdata,
              builder: (context, snapshot) {
                final postsdata = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.grey,));
                }
                else if(snapshot.hasError){
                  return const Center(child: Text("errro"));
                }else {
                  return ScrollablePositionedList.builder(
                    scrollDirection: Axis.vertical,
                    initialScrollIndex: widget.currentImageIndex,
                    shrinkWrap: true,
                      itemCount: postsdata!.size,
                      itemBuilder:(context, index) {
                        bool isLiked = snapshot.data!.docs[index]['likes']
                            .contains(FirebaseAuth.instance.currentUser!.uid);
                        return snapshot.data!.docs[index]['type'] == 'image' ? SingleImagePostCardItemState(
                          postdata: postsdata.docs[index].data(),
                          isLiked: isLiked,) : SingleVideoPostCardItemState(
                          postdata: postsdata.docs[index].data(),
                          isLiked: isLiked,);
                      }
                    );
                }
              },
            );
          }else{
      return const Center(child: CircularProgressIndicator(color: Colors.red,));
    }
        },
),
    );
  }
}
