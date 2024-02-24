import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfilePageInitialEvent>(profilePageInitialEvent);
    on<ProfilePageFetchUserPostEvent>(profilePageFetchUserPostEvent);
    on<ProfilePageFetchUserPostLengthEvent>(profilePageFetchUserPostLengthEvent);
    on<SignOutEvent>(signOutEvent);
  }

  FutureOr<void> profilePageInitialEvent(
      ProfilePageInitialEvent event, Emitter<ProfileState> emit) {
    emit(ProfilePageFetchUserDataLoadingState());
  }

  FutureOr<void> profilePageFetchUserPostEvent(
      ProfilePageFetchUserPostEvent event, Emitter<ProfileState> emit) {
    Stream<QuerySnapshot<Map<String, dynamic>>> postdata =
        _getCurrentUserPosts(event.userid);
    log("emitting ProfilePageFetchUserPostSuccessState(postdata: postdata)");
    emit(ProfilePageFetchUserPostSuccessState(event.postlength,postdata: postdata));
  }

  FutureOr<void> profilePageFetchUserPostLengthEvent(ProfilePageFetchUserPostLengthEvent event, Emitter<ProfileState> emit) async {
    AggregateQuerySnapshot currentUserPostLength =  await _getCurrentUserPostsLength(event.userid);
    log("post length ---------->${currentUserPostLength.count}");
    log("emitting ProfilePageFetchUserPostLengthSuccessState(postlength: currentUserPostLength)");
    emit(ProfilePageFetchUserPostLengthSuccessState(postlength: currentUserPostLength.count));
    add(ProfilePageFetchUserPostEvent(currentUserPostLength.count,userid:event.userid));
  }
}

_getCurrentUserPosts(String? uid) {
  log("uid in gallery2 $uid");
  Stream<QuerySnapshot<Map<String, dynamic>>> posts =  FirebaseFirestore.instance
      .collection("UserPost").orderBy('uploadtime',descending: true)
      .where("uid", isEqualTo: uid.toString())
      .snapshots();
  return posts;
}

Future<AggregateQuerySnapshot> _getCurrentUserPostsLength(String? uid)async {
  log("uid in gallery1 $uid");
AggregateQuerySnapshot posts = await FirebaseFirestore.instance
      .collection("UserPost")
      .where("uid", isEqualTo: uid.toString()).count().get();
  //var postlength =  posts.toString();
 log("aa rha hun mein");
 //log(postlength.toString());
  return posts;
}

FutureOr<void> signOutEvent(
    SignOutEvent event, Emitter<ProfileState> emit) async {
  var auth = FirebaseAuth.instance;
  await auth.signOut();
  emit(SignOutState());
}
