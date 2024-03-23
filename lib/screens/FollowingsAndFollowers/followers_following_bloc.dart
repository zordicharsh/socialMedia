import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/screens/FollowingsAndFollowers/followers_following_event.dart';

import 'followers_following_state.dart';

class FollowingFollowerBloc
    extends Bloc<FollowerFollowingEvent, FollowersFollowing2State> {
  FollowingFollowerBloc() : super(FollowersFollowingInitial()) {
    on<DeleteFollowerFollowingEvent>(deleteFollowerFollowingEvent);
    on<DeleteFollowerFollowingEvent2>(deleteFollowerFollowingEvent2);
  }

  FutureOr<void> deleteFollowerFollowingEvent(
      DeleteFollowerFollowingEvent event,
      Emitter<FollowersFollowing2State> emit) {
    FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(event.UID)
        .update({
      'follower': FieldValue.arrayRemove([event.FollowUserUid])
    });
    FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(event.FollowUserUid)
        .update({
      'following': FieldValue.arrayRemove([event.UID])
    });
  }

  FutureOr<void> deleteFollowerFollowingEvent2(
      DeleteFollowerFollowingEvent2 event,
      Emitter<FollowersFollowing2State> emit) {
    FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(event.UID)
        .update({
      'following': FieldValue.arrayRemove([event.FollowUserUid])
    });
    FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(event.FollowUserUid)
        .update({
      'follower': FieldValue.arrayRemove([event.UID])
    });
  }
}
