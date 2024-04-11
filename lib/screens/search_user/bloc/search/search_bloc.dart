import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/screens/search_user/bloc/search/search_event.dart';
import 'package:socialmedia/screens/search_user/bloc/search/search_state.dart';


class SearchBloc extends Bloc<Searchevents, SearchState> {
  SearchBloc() : super(SearchInitState()) {
    on<SearchUsersIntialEvent>(searchUsersInitialEvent);
    on<SearchTextFieldChangedEvent>(getalluserDetail);
  }

  // Future<void> getalluserDetail(String searchValue) async {
  //   print(searchValue);
  //   if (searchValue.isNotEmpty) {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection("RegisteredUsers")
  //         .orderBy('username')
  //         .startAt([searchValue]).endAt([searchValue + '\uf8ff']).get();
  //     final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  //     // print(snapshot.size);
  //     final UserAuth = FirebaseAuth.instance.currentUser;
  //     userList.assignAll(userdata);
  //   } else if(searchValue.isEmpty){
  //     userList.clear();
  //   }
  // }
  List userList = <UserModel>[];

  FutureOr<void> getalluserDetail(
      SearchTextFieldChangedEvent event, Emitter<SearchState> emit) async {
    log("inside bloc ${event.SearchingValue}");
    if (event.SearchingValue.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection("RegisteredUsers")
          .orderBy('username')
          .startAt([event.SearchingValue]).endAt(
          [event.SearchingValue + '\uf8ff']).get();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
      Stream<QuerySnapshot<Map<String, dynamic>>> userdata1 = await FirebaseFirestore.instance
          .collection("RegisteredUsers")
          .orderBy('username')
          .startAt([event.SearchingValue]).endAt(
          [event.SearchingValue + '\uf8ff']).snapshots();
      ////////////////////////////////////////////////////////////////////////////////////////////////////
      // log(snapshot1.toString());
      final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      print(snapshot.size);
      final UserAuth = FirebaseAuth.instance.currentUser;
      userList.assignAll(userdata);
      print(userList);
      if (userList.isNotEmpty) {
        emit(EmittheUSers(userList,userdata1));
      } else {
        emit(NouserAvailable());
      }
    }
    else {
      emit(SearchInitState());
      userList.clear();
    }
  }

  FutureOr<void> searchUsersInitialEvent(
      SearchUsersIntialEvent event, Emitter<SearchState> emit) {
    emit(SearchInitState());
    userList.clear();
  }
}
