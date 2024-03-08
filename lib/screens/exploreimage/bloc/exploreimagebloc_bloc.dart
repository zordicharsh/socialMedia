import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_event.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_state.dart';

class exploreimageBloc extends Bloc<exploreimageEvents,exploreimageState>{
  exploreimageBloc():super(exploreimageinitstate()){
    on<imagedisplayEvent>(ImageDisplayEvent);

  }




  FutureOr<void> ImageDisplayEvent(imagedisplayEvent event, Emitter<exploreimageState> emit) {
    print("display");
    Stream<QuerySnapshot<Map<String, dynamic>>> UserpostsData =  FirebaseFirestore.instance
        .collection("UserPost")
        .where('acctype', isEqualTo: 'public')
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
    emit(exploreimageshowState(UserpostsData));
  }






}