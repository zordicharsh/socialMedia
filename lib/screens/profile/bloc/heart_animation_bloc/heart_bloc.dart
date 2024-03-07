import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'heart_event.dart';

part 'heart_state.dart';

class HeartBloc extends Bloc<HeartEvent, HeartState> {
  HeartBloc() : super(HeartInitial()) {
    on<ProfilePagePostCardDoubleTapLikedAnimOnPostEvent>(profilePagePostCardDoubleTapLikedAnimOnPostEvent);
    on<ProfilePagePostCardOnPressedLikedAnimOnPostEvent>(profilePagePostCardOnPressedLikedAnimOnPostEvent);
    on<ProfilePagePopUpDialogLikedAnimOnPostEvent>(
        profilePagePopUpDialogLikedOnPostEvent);
  }

  Future<FutureOr<void>> profilePagePopUpDialogLikedOnPostEvent(
      ProfilePagePopUpDialogLikedAnimOnPostEvent event,
      Emitter<HeartState> emit) async {
    if (!event.isLiked) {
      event.isHeartAnimating = true;
    }
    event.isLiked = !event.isLiked;
    emit(ProfilePagePopUpDialogPostLikedActionState(
        event.isLiked, event.isHeartAnimating));
    if (event.isHeartAnimating) {
      event.isHeartAnimating = false;
    }
    log("2nd attempt :- isLiked:- ${event.isLiked} & isHeartAnimating:- ${event.isHeartAnimating}");
  }

  FutureOr<void> profilePagePostCardDoubleTapLikedAnimOnPostEvent(ProfilePagePostCardDoubleTapLikedAnimOnPostEvent event, Emitter<HeartState> emit) async{
    final UserPost = FirebaseFirestore.instance.collection('UserPost');
    final currentUid = await _getCurrentUid();
    final postRef = await UserPost.doc(event.postId).get();

    if(postRef.exists){
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totallikes");
      if(!likes.contains(currentUid)){
        UserPost.doc(event.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totallikes": totalLikes + 1,
        });
      }
    }
  }

  FutureOr<bool> profilePagePostCardOnPressedLikedAnimOnPostEvent(ProfilePagePostCardOnPressedLikedAnimOnPostEvent event, Emitter<HeartState> emit) async{
    final UserPost = FirebaseFirestore.instance.collection('UserPost');
    final currentUid = await _getCurrentUid();
    final postRef = await UserPost.doc(event.postId).get();
        if(postRef.exists){
      List likes = postRef.get("likes");
      final totalLikes = postRef.get("totallikes");
      if(likes.contains(currentUid)){
        UserPost.doc(event.postId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totallikes": totalLikes - 1,
        });
        return true;
      }else{
        UserPost.doc(event.postId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totallikes": totalLikes + 1,
        });
        return false;
      }
    }else{
          return false;
        }
  }


  _getCurrentUid() {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return currentUserUid;
  }
}
