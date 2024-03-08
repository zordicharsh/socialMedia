import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeSideBar extends StatefulWidget {
  const HomeSideBar({super.key, required this.likes, required this.profileUrl, required this.PostId, required this.UploaderUid});
  final List likes;
  // final String comments;
  final String profileUrl;
  final String PostId;
  final String UploaderUid;
  
  @override
  State<HomeSideBar> createState() => _HomeSideBarState();
}

class _HomeSideBarState extends State<HomeSideBar> {
  @override
  Widget build(BuildContext context) {
    final bool isliked = widget.likes.contains(FirebaseAuth.instance.currentUser!.uid);
    print(isliked.toString()+" lubddddddddddddddddddddddddddd");
    TextStyle style = Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 13,color: Colors.white);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _profileImageButton(),
        _sideBarItemForLike(Icons.favorite_outline, widget.likes.length.toString(), style,isliked,widget.PostId),
        _sideBarItem(Icons.comment_outlined, '123', style),
        _sideBarItem(Icons.send_sharp, 'share', style)
      ],
    );
  }


  _sideBarItemForLike(IconData iconName,String label,TextStyle style,bool islike,String postId){
    return Column(
      children: [
        GestureDetector(
            onTap: (){
                if(islike){
                  DocumentReference _currentUserRef =
                  FirebaseFirestore.instance
                      .collection('UserPost')
                      .doc(widget.PostId);
                  _currentUserRef.update({
                    'likes': FieldValue.arrayRemove([
                      FirebaseAuth
                          .instance.currentUser!.uid
                    ])
                  });
                }else{
                  DocumentReference _currentUserRef =
                  FirebaseFirestore.instance
                      .collection('UserPost')
                      .doc(widget.PostId);
                  _currentUserRef.update({
                    'likes': FieldValue.arrayUnion([
                      FirebaseAuth
                          .instance.currentUser!.uid
                    ])
                  });
                }
            },
            child: islike ? const Icon(Icons.favorite,size: 28, color: Colors.red,):Icon(iconName,size: 28,)),
        const SizedBox(height: 5,),
        Text(label,style: style,)
      ],
    );
  }




  _sideBarItem(IconData iconName,String label,TextStyle style){
    return Column(
      children: [
        GestureDetector(
          onTap: (){

          },
            child: Icon(iconName,size: 28)),
        const SizedBox(height: 5,),
        Text(label,style: style,)
      ],
    );
  }

  _profileImageButton(){
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(image: NetworkImage(widget.profileUrl))
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("RegisteredUsers").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                List following = snapshot.data!.get('following');
                bool isfollowing = following.contains(widget.UploaderUid);
                if(isfollowing==true){
                  return Positioned(bottom: -8,
                      child: Container(

                      ));
                }else{
                  return Positioned(bottom: -8,
                      child: GestureDetector(
                        onTap: (){
                          DocumentReference _videoPostUser = FirebaseFirestore.instance.collection('RegisteredUsers').doc(widget.UploaderUid);
                          _videoPostUser.update({
                            'follower':FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
                          });
                          DocumentReference _videoPostUser1 = FirebaseFirestore.instance.collection('RegisteredUsers').doc(FirebaseAuth.instance.currentUser!.uid);
                          _videoPostUser1.update({
                            'following':FieldValue.arrayUnion([widget.UploaderUid])
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" you started follow ")));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,borderRadius: BorderRadius.circular(24)
                          ),
                          child: const Icon(Icons.add,size: 20,),
                        ),
                      ));
                }
              }else{
                return Container();
              }

            }
          )
        ],
    );
  }
}
