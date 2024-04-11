// Bloc

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/screens/follow_request_screen/bloc/request_event.dart';
import 'package:socialmedia/screens/follow_request_screen/bloc/request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc() : super(RequestInitial()) {
    on<AcceptFollowRequestEvent>(acceptFollowRequestEvent);
    on<DeleteFollowRequestEvent>(deleteFollowRequestEvent);
  }

//   FutureOr<void> followingRequestDataFromCurrentUser(FollowingRequestDataFromCurrentUser event, Emitter<RequestState> emit) async {
//     var UID = FirebaseAuth.instance.currentUser!.uid;
//     var followersUid = await GetCurrentUserFollowers(UID); // Wait for Future to complete
//     Stream<QuerySnapshot<Map<String, dynamic>>> postdata = GetFollowerUserData(followersUid);
//     print(postdata);
//     print("${followersUid}ssssssssssssssssssss");
//     emit(RequestFollowerDataState(postdata));
//   }
//
//   Future<List<dynamic>> GetCurrentUserFollowers(String uid) async {
//     var response = await FirebaseFirestore.instance
//         .collection("RegisteredUsers")
//         .doc(uid)
//         .get();
//     if (response.exists) {
//       print(response.get('follower'));
//       return List.from(response.get('follower'));
//     } else {
//       return [];
//     }
//   }
//
//   GetFollowerUserData(List<dynamic> followersUid) {
//     return FirebaseFirestore.instance
//         .collection("RegisteredUsers")
//         .where("uid", whereIn: followersUid)
//         .snapshots();
//   }

  FutureOr<void> acceptFollowRequestEvent(
      AcceptFollowRequestEvent event, Emitter<RequestState> emit) {
    FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(event.UID)
        .update({
      'follower': FieldValue.arrayUnion([event.FollowUserUid]),
      'followrequest': FieldValue.arrayRemove([event.FollowUserUid]),
      'followrequestnotification':
          FieldValue.arrayRemove([event.FollowUserUid]),
    });
    FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(event.FollowUserUid)
        .update({
      'following': FieldValue.arrayUnion([event.UID])
    });
  }

  FutureOr<void> deleteFollowRequestEvent(
      DeleteFollowRequestEvent event, Emitter<RequestState> emit) {
    FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(event.UID)
        .update({
      'followrequestnotification': FieldValue.arrayRemove([event.FollowUserUid])
    });
  }
}
