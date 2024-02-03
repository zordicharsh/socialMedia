import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_model.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalInitial()) {
    log("nice");
    on<GetUserIDEvent>(getUserIDEvent);
    log("in global bloc");
  }

  FutureOr<void> getUserIDEvent(
      GetUserIDEvent event, Emitter<GlobalState> emit) async {
    log("in global bloc's getUserIDEvent");

    List<UserModel> userdata;
    userdata = await getUserDetail(event.uid);

    emit(GetUserDataFromGlobalBlocState(userdata));
    log("emitted GetUserIDFromGlobalBlocState(userID) ");
  }

  Future<List<UserModel>> getUserDetail(String? uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("RegisteredUsers")
        .where("uid", isEqualTo: uid.toString())
        .get();
    log("uid $uid");
    log("data from getUserDetail method ${snapshot.docs.length.toString()}");
    return snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
  }
}
