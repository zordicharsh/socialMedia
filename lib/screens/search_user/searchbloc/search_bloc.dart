
import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_event.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_state.dart';

class SearchBloc extends Bloc<Searchevents,SearchState>{
  SearchBloc():super(SearchInitState()){
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
  FutureOr<void> getalluserDetail(SearchTextFieldChangedEvent event, Emitter<SearchState> emit) async{
      print(event.SearchingValue);
      if (event.SearchingValue.isNotEmpty) {
        final snapshot = await FirebaseFirestore.instance
            .collection("RegisteredUsers")
            .orderBy('username')
            .startAt([event.SearchingValue]).endAt([event.SearchingValue + '\uf8ff']).get();
        final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
        print(snapshot.size);
        final UserAuth = FirebaseAuth.instance.currentUser;
        userList.assignAll(userdata);
        print(userList);
        if(userList.isEmpty){
          emit(NouserAvailable());
        }
        if(userList.isNotEmpty){
        emit(EmittheUSers(userList));
        }



      }
      else{
        userList.clear();
        emit(SearchInitState());
      }

  }
}