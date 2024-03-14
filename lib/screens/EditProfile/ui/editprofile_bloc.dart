import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_event.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_state.dart';

class EditprofileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditprofileBloc() : super(EditProfileInitialState()) {
    on<GetUserAlldataEvent>(getUserAlldataEvent);
    on<EditProfileDataPassEvent>(editProfileDataPassEvent);
    on<EditProfileDataPassEvent2>(editProfileDataPassEvent2);
    on<EditProfilUserNameCheckEvent>(editProfilUserNameCheckEvent);
    on<ShowingNullProfile>(showingNullProfile);
  }

  //////////////////////////////////////////////////  UserName check Kerne vala Methode /////////////////////////////////
  Future<void> editProfilUserNameCheckEvent(EditProfilUserNameCheckEvent event,
      Emitter<EditProfileState> emit) async {
    var uuid = FirebaseAuth.instance.currentUser!.uid;
    var response = await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .where('username', isEqualTo: event.Username.trim())
        .get();
    String? kk;
    String? UID;
    if (response.docs.isNotEmpty) {
      for (var value in response.docs) {
        kk = value['username'].toString();
        UID = value['uid'].toString();
      }
    }
    if (event.Username == kk && uuid == UID) {
      emit(EditProfileSuccessState());
    }
    else if (event.Username == kk && uuid != UID) {
      if (event.UrLL == "") {
        emit(EditProfileUserNameErrorState("This Username Already exist"));
        emit(IfUserProfilePicIsNull(event.naam, event.Username, event.BIO));
      } else {
        emit(EditProfileUserNameErrorState("This Username Already exist"));
        emit(GetUserAllDataState(
            event.naam, event.Username, event.BIO, event.UrLL));
      }
    }
    else {
      emit(EditProfileSuccessState());
    }
  }

  ////////////////////////////////////////// image store and download url kerne vala methode ////////////////////////
  Future<void> editProfileDataPassEvent(EditProfileDataPassEvent event,
      Emitter<EditProfileState> emit) async {
    var pathimage = event.imageFile.toString();
    var temp = pathimage.lastIndexOf('/');
    var result = pathimage.substring(temp + 1);
    final ref = FirebaseStorage.instance.ref().child("Profile_Images").child(
        result);
    var response = await ref.putFile(event.imageFile!);
    print("update $response");
    var imageUrl = await ref.getDownloadURL();
    UpdateProfile(imageUrl, event.name.toString(), event.username.toString(),
        event.bio.toString());
  }

  void UpdateProfile(String url, String name, String username,
      String bio) async {
    print("UNDER DOWNLOD Successsssssssssssssssssssssssssssssssssss");
    var uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(uid)
        .update({
      "profileurl": url,
      "bio": bio,
      "name": name,
      "username": username
    });
    UdateUsernameInPostCollection(username.toString().trim(), url.toString().trim());
    print("UNDER DOWNLOD Successsssssssssssssssssssssssssssssssssss");
    emit(EditProfileMessageSuccessState("Success upload", username, uid!));
  }

  ////////////////////////////////////////  PostCollection Me UserName Change Kerne vala Method /////////////////////////////////
  void UdateUsernameInPostCollection(String PostUsername, String url) async {
    await FirebaseFirestore.instance
        .collection('UserPost')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get().then((value) {
      for (var i in value.docs) {
        i.reference.update({'username': PostUsername});
        i.reference.update({'profileurl': url});
      }
    },
    );
  }

/////////////////////////////////////////////////////// URL NULL VALA METHODE ////////////////////////////////////////////////////

  Future<void> editProfileDataPassEvent2(EditProfileDataPassEvent2 event,
      Emitter<EditProfileState> emit) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(uid)
        .update({
      "profileurl": event.kuchnahi,
      "bio": event.bio,
      "name": event.name,
      "username": event.username
    });
    UdateUsernameInPostCollection(
        event.username.toString().trim(), event.kuchnahi.toString());
    print("nullllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
    emit(EditProfileMessageSuccessState(
        "Successfull uploaded", event.username.toString(), uid!));
    if (event.kuchnahi.toString() != "") {
      emit(GetUserAllDataState(event.name.toString(), event.username.toString(),
          event.bio.toString(), event.kuchnahi.toString()));
    }
  }

////////////////////////// fetching user data ////////////////////////////////

  Future<void> getUserAlldataEvent(GetUserAlldataEvent event,
      Emitter<EditProfileState> emit) async {
    var uidd = FirebaseAuth.instance.currentUser!.uid;
    var response = await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .where('uid', isEqualTo: uidd)
        .get();
    late String use;
    late String bio;
    late String naam;
    late String Url;
    if (response.docs.isNotEmpty) {
      for (var value in response.docs) {
        use = value['username'].toString();
        bio = value['bio'].toString();
        naam = value['name'].toString();
        Url = value['profileurl'].toString();
      }
    }
    if (Url == "") {
      print("URlllllllllllllllllllllllllllllll");
      emit(IfUserProfilePicIsNull(naam, use, bio));
    }
    else {
      print("MotNullUrllllllllllllllllllllllllllllllllll");
      emit(GetUserAllDataState(naam, use, bio, Url));
    }
  }

  FutureOr<void> showingNullProfile(ShowingNullProfile event,
      Emitter<EditProfileState> emit) {
    emit(IfUserProfilePicIsNull(
        event.name.toString(), event.username.toString(),
        event.bio.toString()));
  }

}