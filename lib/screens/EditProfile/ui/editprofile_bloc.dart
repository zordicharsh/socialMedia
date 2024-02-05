import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_event.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_state.dart';

class EditprofileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditprofileBloc() : super(EditProfileInitialState()) {
    on<EditProfileDataPassEvent>(editProfileDataPassEvent);
    on<EditProfileDataPassEvent2>(editProfileDataPassEvent2);
    on<EditProfilUserNameCheckEvent>(editProfilUserNameCheckEvent);
  }
  Future<void> editProfileDataPassEvent(
      EditProfileDataPassEvent event, Emitter<EditProfileState> emit) async {
    var pathimage = event.imageFile.toString();
    var temp = pathimage.lastIndexOf('/');
    var result = pathimage.substring(temp + 1);
    final ref =
        FirebaseStorage.instance.ref().child("product_images").child(result);
    var response = await ref.putFile(event.imageFile!);
    print("update $response");
    var imageUrl = await ref.getDownloadURL();
    print("UNDER DOWNLOD URLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
    UpdateProfile(imageUrl, event.name.toString(), event.username.toString(),
        event.bio.toString());
  }

  void UpdateProfile(
      String url, String name, String username, String bio) async {
    print("UNDER DOWNLOD Successsssssssssssssssssssssssssssssssssss");
    await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "profileurl": url,
      "bio": bio,
      "name": name,
      "username": username
    });
    print("UNDER DOWNLOD Successsssssssssssssssssssssssssssssssssss");
    emit(EditProfileMessageSuccessState("Success upload"));
  }

/////////////////////////////////////////////////////// URL NULL VALA METHODE ////////////////////////////////////////////////////
  Future<void> editProfileDataPassEvent2(
      EditProfileDataPassEvent2 event, Emitter<EditProfileState> emit) async {
    await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      "profileurl": event.kuchnahi,
      "bio": event.bio,
      "name": event.name,
      "username": event.username
    });
    print("nullllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
    emit(EditProfileMessageSuccessState("Success upload"));
  }

  Future<void> editProfilUserNameCheckEvent(EditProfilUserNameCheckEvent event,
      Emitter<EditProfileState> emit) async {
    var response = await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .where('username', isEqualTo: event.Username.trim())
        .get();
    print(response.toString());
    if (response.docs.isNotEmpty) {
      print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
      emit(EditProfileUserNameErrorState("This UserName Already Exits"));
    } else {
      print("ccccccccccccccccccccccccccccccccccc");
      emit(EditProfileSuccessState());
    }
  }
}
