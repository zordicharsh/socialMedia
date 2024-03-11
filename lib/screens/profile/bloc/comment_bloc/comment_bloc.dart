import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'comment_event.dart';

part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentInitial()) {
    on<FetchCommentsOfUserPost>(fetchCommentsOfUserPost);
    on<UploadCommentsOfUserPost>(uploadCommentsOfUserPost);
    on<DeleteCommentsOfUserPost>(deleteCommentsOfUserPost);
    on<PostCardCommentSectionDoubleTapLikedAnimOnCommentEvent>(postCardCommentSectionDoubleTapLikedAnimOnCommentEvent);
    on<PostCardCommentSectionOnPressedLikedAnimOnCommentEvent>(postCardCommentSectionOnPressedLikedAnimOnCommentEvent);
  }

  FutureOr<void> uploadCommentsOfUserPost(
      UploadCommentsOfUserPost event, Emitter<CommentState> emit) async{
    await uploadCommentsOnUserPosts(
        event.postid, event.text);
  }

  Future<FutureOr<void>> fetchCommentsOfUserPost(FetchCommentsOfUserPost event, Emitter<CommentState> emit) async {
    final Stream<QuerySnapshot<Map<String, dynamic>>> commentdata =  await fetchUploadedCommentsOnUserPosts(
        event.postid);
    emit(FetchCommentsOfUserPostSuccessState(commentdata));
  }

  _getCommentorUid(){
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    return currentUserUid;
  }

  _getCommentorUsername() async {
    String commentorUid = await _getCommentorUid();
    String commentorUsername =  await FirebaseFirestore.instance.collection("RegisteredUsers").doc(commentorUid).get().then((value) {
      if(value.exists){
        return value.get('username');
      }
      else{
        return "";
      }
    });
    return commentorUsername;
  }

  _getCommentorProfileUrl() async {
    String commentorUid =await _getCommentorUid();
    String commentorProfileUrl =  await FirebaseFirestore.instance.collection("RegisteredUsers").doc(commentorUid).get().then((value) {
      if(value.exists){
        return value.get('profileurl');
      }
      else{
        return "";
      }
    });
    return commentorProfileUrl;
  }

  Future<void> uploadCommentsOnUserPosts(String postid, String text) async {
    try {
      if (text.isNotEmpty) {
        String commentid = DateTime.now().millisecondsSinceEpoch.toString();
        String commentorUid =await  _getCommentorUid();
        log(commentorUid);
        String commentorUsername = await _getCommentorUsername();
        log(commentorUsername);
        String commentorProfileUrl =await _getCommentorProfileUrl();

        var commentCollection = FirebaseFirestore.instance
            .collection('UserPost')
            .doc(postid)
            .collection('comments');
        var commentDocRef = await commentCollection.doc(commentid).get();
        if (!commentDocRef.exists) {
          commentCollection.doc(commentid).set({
            'profileurl': commentorProfileUrl,
            'username': commentorUsername,
            'uid': commentorUid,
            'text': text,
            'commentid': commentid,
            'uploadtime': DateTime.now().toIso8601String(),
            'likes': [],
            'totallikes': 0,
          }).then((value) async {
            final UserPost =
               await FirebaseFirestore.instance.collection("UserPost").doc(postid);
            UserPost.get().then((value) {
              if(value.exists){
                final totalComments = value.get('totalcomments');
                UserPost.update({"totalcomments": totalComments + 1});
                return;
              }
            });
          });
        }
      } else {
        log("comment text is empty");
      }
    } catch (e) {
      log(e.toString());
    }
  }
  Future<void> deleteuploadedCommentsOnUserPosts(String commentid,String postid) async {
    try {

        var commentCollection = FirebaseFirestore.instance
            .collection('UserPost')
            .doc(postid)
            .collection('comments');
        log("-------------->commentid :- $commentid");
        commentCollection.doc(commentid).delete().then((value) async{
          final UserPost =
             await FirebaseFirestore.instance.collection("UserPost").doc(postid);
          UserPost.get().then((value) async{
            if (value.exists) {
              final totalComments = value.get('totalcomments');
            await  UserPost.update({"totalcomments": totalComments - 1});
              return;
            }
          });
        });
    } catch (e) {
      log(e.toString());
    }
  }
 fetchUploadedCommentsOnUserPosts(String postid) {
    final commentCollection = FirebaseFirestore.instance.collection('UserPost').doc(postid).collection('comments').orderBy('uploadtime',descending: true);
    return commentCollection.snapshots();
      }
  FutureOr<void> deleteCommentsOfUserPost(DeleteCommentsOfUserPost event, Emitter<CommentState> emit) async{
    log("${event.commentid}");
    await deleteuploadedCommentsOnUserPosts(event.commentid,event.postid) ;
   // add(FetchCommentsOfUserPost(event.postid));
  }

  FutureOr<void> postCardCommentSectionDoubleTapLikedAnimOnCommentEvent(PostCardCommentSectionDoubleTapLikedAnimOnCommentEvent event, Emitter<CommentState> emit) async{
    final UserPostRef = FirebaseFirestore.instance.collection('UserPost').doc(event.postId);
    final currentUid = await _getCommentorUid();
    final commentRef = await UserPostRef.collection("comments").doc(event.commentId).get();

    if(commentRef.exists){
      List likes = commentRef.get("likes");
      final totalLikes = commentRef.get("totallikes");
      if(!likes.contains(currentUid)){
        UserPostRef.collection("comments").doc(event.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totallikes": totalLikes + 1,
        });
      }
    }
  }

  FutureOr<void> postCardCommentSectionOnPressedLikedAnimOnCommentEvent(PostCardCommentSectionOnPressedLikedAnimOnCommentEvent event, Emitter<CommentState> emit) async{
    final UserPostRef = FirebaseFirestore.instance.collection('UserPost').doc(event.postId);
    final currentUid = await _getCommentorUid();
    final commentRef = await UserPostRef.collection("comments").doc(event.commentId).get();
    if(commentRef.exists){
      List likes = commentRef.get("likes");
      final totalLikes = commentRef.get("totallikes");
      if(likes.contains(currentUid)){
        UserPostRef.collection("comments").doc(event.commentId).update({
          "likes": FieldValue.arrayRemove([currentUid]),
          "totallikes": totalLikes - 1,
        });
      }else{
        UserPostRef.collection("comments").doc(event.commentId).update({
          "likes": FieldValue.arrayUnion([currentUid]),
          "totallikes": totalLikes + 1,
        });
        return;
      }
    }
  }
}
