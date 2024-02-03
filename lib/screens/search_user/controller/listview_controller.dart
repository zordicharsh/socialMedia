import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../model/user_model.dart';

class ListViewController extends GetxController {
  RxList<UserModel> userList = <UserModel>[].obs;
  Future<void> getalluserDetail(String searchValue) async {
    print(searchValue);
    if (searchValue.isNotEmpty) {
      final snapshot = await FirebaseFirestore.instance
          .collection("RegisteredUsers")
          .orderBy('username')
          .startAt([searchValue]).endAt([searchValue + '\uf8ff']).get();
      final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
      // print(snapshot.size);
      final UserAuth = FirebaseAuth.instance.currentUser;
      userList.assignAll(userdata);

    } else if(searchValue.isEmpty){
      userList.clear();
    }
  }

}
