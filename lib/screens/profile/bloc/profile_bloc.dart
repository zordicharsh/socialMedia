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
    on<SignOutEvent>(signOutEvent);


  }
  FutureOr<void> profilePageInitialEvent(ProfilePageInitialEvent event, Emitter<ProfileState> emit) {
    emit(ProfilePageFetchUserDataLoadingState());
  }


  FutureOr<void> profilePageFetchUserPostEvent(ProfilePageFetchUserPostEvent event, Emitter<ProfileState> emit) {
    Stream<QuerySnapshot<Map<String, dynamic>>> postdata = _getCurrentUserPosts(event.userid);
    emit(ProfilePageFetchUserPostSuccessState(postdata: postdata));

  }
}
_getCurrentUserPosts(String? uid) {
  log("uid in gallery $uid");
  Stream<QuerySnapshot<Map<String, dynamic>>> posts = FirebaseFirestore.instance
      .collection("UserPost")
      .where("uid", isEqualTo: uid.toString()).snapshots();
  return posts;
}
FutureOr<void> signOutEvent(SignOutEvent event,
    Emitter<ProfileState> emit) async {
  var auth = FirebaseAuth.instance;
  await auth.signOut();
  emit(SignOutState());
}
