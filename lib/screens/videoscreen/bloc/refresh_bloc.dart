import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:socialmedia/screens/explorescreen/ui/explorescreen.dart';

part 'refresh_event.dart';
part 'refresh_state.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  RefreshBloc() : super(InitState()) {
    on<InitEvent>(initevent);
    on<DoRefreshEvent>(dorefreshevent);
  }
  FutureOr<void> initevent(InitEvent event, Emitter<RefreshState> emit) {
    Stream<QuerySnapshot<Map<String, dynamic>>> alluserdata =  FirebaseFirestore.instance
        .collection("UserPost")
        .where('type', isEqualTo: "video")
        .where('acctype', isEqualTo: "public")
        .snapshots();
   emit(RefreshInitial(Alluserdata: alluserdata));

  }

  FutureOr<void> dorefreshevent(DoRefreshEvent event, Emitter<RefreshState> emit) {
    Stream<QuerySnapshot<Map<String, dynamic>>> RandomData =  FirebaseFirestore.instance
        .collection("UserPost")
        .where('type', isEqualTo: "video")
        .where('acctype', isEqualTo: "public")
        .snapshots();
    List<DocumentSnapshot> filteredList = [];
    RandomData.forEach((element) async{
      element.docs.forEach((element) {
       filteredList.add(element);
      });
    });


    emit(RefreshDoneState(RandomData: RandomData,filteredList: filteredList));

  }
}
