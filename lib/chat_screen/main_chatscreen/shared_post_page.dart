
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../../screens/profile/ui/widgets/single(post_card)state.dart';

class SharedPostInChatItemState extends StatefulWidget {
  const SharedPostInChatItemState(
      {super.key, required this.postdata});

  final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> postdata;

  @override
  State<SharedPostInChatItemState> createState() =>
      _SharedPostInChatItemStateState();
}

class _SharedPostInChatItemStateState extends State<SharedPostInChatItemState> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 32,
        ),
        backgroundColor: Colors.black,
        title: const Text(
          "SocialRizz",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),      body: StreamBuilder(
      stream:  FirebaseFirestore
          .instance
          .collection('UserPost')
          .where('postid',isEqualTo:widget.postdata.data!.get('postid'))
          .snapshots(),
        builder:(context, snapshot) {
          final postsdata = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.grey,));
          }
          else if(snapshot.hasError){
            return const Center(child: Text("error"));
          }else {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: postsdata!.size,
                itemBuilder:(context, index) => SinglePostCardItemState(index: index,postdata: postsdata)
            );
          }
        },


      ),
    );
  }
}
/*
Column(
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
widget.postdata.data!.get('profileurl') != ""
? CachedNetworkImage(
imageUrl: widget.postdata.data!.get
('profileurl'),
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
widget.postdata.data!.get('username'),
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
height: widget.postdata.data!.get('type') == 'image'
? MediaQuery.sizeOf(context).height * 0.45
    : MediaQuery.sizeOf(context).height * 0.64,
width: double.infinity,
child: ZoomOverlay(
modalBarrierColor: Colors.black12,
minScale: 0.5,
maxScale: 3.0,
animationCurve: Curves.fastOutSlowIn,
animationDuration: const Duration(milliseconds: 300),
twoTouchOnly: true,
onScaleStart: () {},
onScaleStop: () {},
child: GestureDetector(
onTap: () {
setState((){
isVideoPlaying = !isVideoPlaying;
isVideoPlaying == false
? videoPlayerController!.pause()
    : videoPlayerController!.play();
*/
/* if(isVideoPlaying){
                          position = await getCurrentVideoDuration();
                        }*//*

});
log(isVideoPlaying.toString());
},
onDoubleTap: () {
log(widget.postdata.data!.get('postid'));
setState(() {
log("starting like animation");
isHeartAnimating = true;
isLiked = true;
});
BlocProvider.of<HeartBloc>(context).add(
ProfilePagePostCardDoubleTapLikedAnimOnPostEvent(
widget.postdata.data!.get('postid')));
},
child: Stack(
alignment: Alignment.bottomRight,
children: [
Center(
child: SizedBox(
width: double.infinity,
child: widget.postdata.data!.get('type') == 'image'
? Image(
fit: BoxFit.cover,
filterQuality: FilterQuality.high,
image: CachedNetworkImageProvider(
widget.postdata.data!.get('posturl')
    .toString(),
))
    :  !videoPlayerController!.value.isInitialized
? CachedNetworkImage(
imageUrl: widget.postdata
    .data!.get('thumbnail'),
fit: BoxFit.cover,
filterQuality: FilterQuality.low,
)
    : AspectRatio(aspectRatio: videoPlayerController!.value.aspectRatio,child: VideoPlayer(videoPlayerController!)),
),
),
widget.postdata.data!.get('type') != 'image'
? isVideoPlaying == true
? Positioned(
top: 16.sp,
left: 320.sp,
child: const Icon(
CupertinoIcons.pause_solid,
color: Colors.white70,
))
    : Positioned(
top: 16.sp,
left: 320.sp,
child: const Icon(
CupertinoIcons.play_arrow_solid,
color: Colors.white70,
))
    : const SizedBox.shrink(),
Center(
child: AnimatedOpacity(
duration: const Duration(milliseconds: 300),
opacity: isHeartAnimating ? 1 : 0,
child: HeartAnimationWidget(
duration: const Duration(milliseconds: 200),
onEnd: () => setState(() {
log("making  isHeartAnimating = false from on end");
isHeartAnimating = false;
}),
isAnimating: isHeartAnimating,
child: Icon(
CupertinoIcons.heart_fill,
color: Colors.white,
size: 100,
semanticLabel: 'You Liked A Post',
shadows: [
BoxShadow(
blurRadius: 50,
spreadRadius: 20,
color: Colors.black.withOpacity(0.4),
blurStyle: BlurStyle.normal,
offset: const Offset(3, 3))
],
),
),
),
),
widget.postdata.data!.get('type') == 'video'
? Padding(
padding: const EdgeInsets.symmetric(
vertical: 8.0, horizontal: 8.0),
child: GestureDetector(
onTap: () => setState(() {
isMute = !isMute;
isMute == false
? videoPlayerController!
    .setVolume(previousVideoVolume)
    : videoPlayerController!.setVolume(0);
}),
child: CircleAvatar(
radius: 16,
backgroundColor: Colors.black.withOpacity(0.8),
child: Center(
child: isMute == false
? const Icon(
Icons.volume_up_sharp,
size: 18,
color: Colors.white,
)
    : const Icon(
Icons.volume_off_sharp,
size: 18,
color: Colors.white,
))),
),
) : const SizedBox.shrink(),
]),
),
)),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Row(
children: [
HeartAnimationWidget(
isAnimating: isLiked,
alwaysAnimate: true,
duration: const Duration(milliseconds: 150),
onEnd: () {
if (isLiked) {
setState(() {
isHeartAnimating = false;
});
}
},
child: IconButton(
highlightColor: Colors.transparent,
onPressed: () {
BlocProvider.of<HeartBloc>(context).add(
ProfilePagePostCardOnPressedLikedAnimOnPostEvent(
widget.postdata.data!.get('postid')));
setState(() {
if (!isLiked) {
isHeartAnimating = true;
}
isLiked = !isLiked;
});
},
icon: Icon(
size: 28,
isLiked
? CupertinoIcons.heart_fill
    : CupertinoIcons.heart,
color: isLiked ? Colors.red : Colors.white,
),
),
),
IconButton(
highlightColor: Colors.black.withOpacity(0),
onPressed: () {
showModalBottomSheet(
isScrollControlled: true,
elevation: 0,
backgroundColor: Colors.transparent,
context: context,
builder: (context) {
return DraggableScrollableSheet(
snap: true,
snapSizes: const [0.71, 0.72],
maxChildSize: 0.96,
initialChildSize: 0.96,
minChildSize: 0.4,
builder: (context, scrollController) =>
CommentSection(
postId: widget.postdata.data!.get
('postid'),
scrollController: scrollController,
username: widget.postdata.data!.get
('username'),
uidofpostuploader:
widget.postdata.data!.get('uid'),
));
},
);
},
icon: const Icon(
CupertinoIcons.chat_bubble,
size: 26,
),
color: Colors.white,
),
IconButton(
highlightColor: Colors.transparent,
onPressed: () {},
icon: const Icon(
CupertinoIcons.paperplane,
size: 24,
),
color: Colors.white,
),
],
),
Row(
children: [
IconButton(
highlightColor: Colors.transparent,
onPressed: () {
BlocProvider.of<ProfileBloc>(context).add(DeletePostEvent(widget.postdata.data!.get('postid'),));
},
icon: const Icon(
CupertinoIcons.bookmark,
size: 24,
),
color: Colors.white,
)
],
),
],
),
Padding(
padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
child:
Text("${widget.postdata.data!.get('totallikes')} likes"),
),
const SizedBox(
height: 4,
),
Padding(
padding: const EdgeInsets.only(left: 12, right: 16),
child: ReadMoreText(
widget.postdata.data!.get('caption'),
delimiter: '...',
preDataText: widget.postdata.data!.get('username'),
preDataTextStyle: const TextStyle(fontWeight: FontWeight.bold),
trimCollapsedText: 'View More',
trimExpandedText: '  View Less',
trimMode: TrimMode.Length,
trimLength: 64,
moreStyle: TextStyle(
fontSize: 10.sp,
color: Colors.white60,
),
lessStyle: TextStyle(
fontSize: 10.sp,
color: Colors.white60,
),
)),
widget.postdata.data!.get('totalcomments') > 2
? Padding(
padding: const EdgeInsets.only(
top: 4.0, right: 12, left: 12, bottom: 4),
child: GestureDetector(
onTap: () {
showModalBottomSheet(
isScrollControlled: true,
elevation: 0,
backgroundColor: Colors.transparent,
context: context,
builder: (context) {
return DraggableScrollableSheet(
snap: true,
snapSizes: const [0.71, 0.72],
maxChildSize: 0.96,
initialChildSize: 0.96,
minChildSize: 0.4,
builder: (context, scrollController) =>
CommentSection(
postId: widget.postdata.data!.get
('postid'),
scrollController: scrollController,
username: widget.postdata.data!.get('username'),
uidofpostuploader: widget
    .postdata.data!.get('uid'),
));
},
);
},
child: Text(
"View all ${widget.postdata.data!.get('totalcomments')} comments",
style: const TextStyle(color: Colors.white60))),
)
    : Row(
children: [
StreamBuilder(stream: _currentUserDataStream, builder: (context, snapshot) {
if(snapshot.connectionState == ConnectionState.waiting){
return Padding(
padding: const EdgeInsets.only(left: 12.0),
child: CircleAvatar(
radius: 12.1,
backgroundColor: Colors.white,
child: CircleAvatar(
backgroundColor: Colors.black.withOpacity(0.8),
radius: 12,
),
),
);
}
else if(snapshot.hasError){
return const Text("error");
}
else{
var userData = snapshot.data!.data() as Map<String, dynamic>;
return userData['profileurl'] != ""
? Padding(
padding: const EdgeInsets.only(left:12.0),
child: CachedNetworkImage(
imageUrl:userData['profileurl'],
imageBuilder: (context, imageProvider) =>
CircleAvatar(
radius: 12.1,
backgroundColor: Colors.white,
child: CircleAvatar(
backgroundColor: Colors.grey,
backgroundImage: imageProvider,
radius: 12,
),
),
),
)
    : Padding(
padding: const EdgeInsets.only(left:12.0),
child: CircleAvatar(
radius: 12.1,
backgroundColor: Colors.white,
child: CircleAvatar(
backgroundColor: Colors.black.withOpacity(0.8),
radius: 12,
child: Icon(Icons.person,
color: Colors.black.withOpacity(0.5)),
),
),
);
}
},),
const SizedBox(
width: 12,
),
SizedBox(
height: 40.h,
width: 224.w,
child: TextField(
style: TextStyle(fontSize: 11.sp),
// onChanged: (value) => _showCommentShareButton(value),
controller: comment,
// autofocus: true,
readOnly: true,
onTap: () {
showModalBottomSheet(
isScrollControlled: true,
elevation: 0,
backgroundColor: Colors.transparent,
context: context,
builder: (context) {
return DraggableScrollableSheet(
snap: true,
snapSizes: const [0.71, 0.72],
maxChildSize: 0.96,
initialChildSize: 0.96,
minChildSize: 0.4,
builder: (context, scrollController) =>
CommentSection(
postId: widget.postdata.data!.get('postid'),
scrollController: scrollController,
username: widget.postdata
    .data!.get('username'),
uidofpostuploader: widget
    .postdata.data!.get('uid'),
));
},
);
},
decoration: InputDecoration(
hintText: widget.postdata.data!.get('uid') ==
FirebaseAuth.instance.currentUser?.uid
? 'Add a comment...'
    : 'Add a comment for ${widget.postdata.data!.get('username')}...',
hintStyle: TextStyle(
fontSize: 10.sp,
fontWeight: FontWeight.w400,
color: Colors.white70),
border: InputBorder.none,
),
),
),
],
),
Padding(
padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
child: Text(
DateFormat.d().add_yMMM().format(
widget.postdata.data!.get('uploadtime').toDate()),
style: const TextStyle(color: Colors.white60)),
),
const SizedBox(
height: 16,
),
],
),*/
