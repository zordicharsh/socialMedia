import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as Path;
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_event.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_state.dart';

import '../../../model/user_post__picture_model.dart';

class UserpostBloc extends Bloc<UserpostEvents, UserPostStates> {
  UserpostBloc() : super(UserPostinitState()) {
    on<UsergetImage>(userUploadImagebtn);
    on<UserClickonPostbtn>(userClickOnPostBtn);
    on<UserVideoPost>(userVideoPost);
    on<UserGetVideo>(userGetVideo);
    on<UserRemoveViedoOrImageEvent>(userRemoveViedoOrImageEvent);
  }

  File? image;
  String? videopath;
  final picker = ImagePicker();
  //////////////////// this for Image /////////////////////////////////////////
  FutureOr<void> userUploadImagebtn(
      UsergetImage event, Emitter<UserPostStates> emit) async{
    print("object");
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ImageCropMethod(File(pickedFile.path));
      // print(image);
    }
    else {
      emit(UnSuccessFullySelectedImage());
    }
  }
  ////////////////////////// this for Video ////////////////////
  Future<void> userGetVideo(UserGetVideo event, Emitter<UserPostStates> emit) async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
        image = File(pickedFile.path);
      //  VideoCompresss(File(pickedFile.path));
        emit(SuccessFullySelectedVideo(image));
    }
    else
      {
        emit(UnSuccessFullySelectedImage());
      }
  }
/////////////////////////  Image Croperrrrr /////////////////////
  Future<void> ImageCropMethod(File file)
  async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        compressQuality: 20,
        aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
        AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        cropFrameColor: Colors.blue.withOpacity(0.7),
    cropGridColor: Colors.blue.withOpacity(0.4),
    showCropGrid: true,
    initAspectRatio: CropAspectRatioPreset.original,
    lockAspectRatio: false,
    ),
    ]);
    if(croppedImage != null)
      {
        image = File(croppedImage.path);
        emit(SuccessFullySelectedImage(image));
      }
    else{
      emit(UnSuccessFullySelectedImage());
    }
  }
//////////////////////// video compreserrrrr ///////////////////
/* Future<void> VideoCompresss(File VideoFile)  async {
    final pickedddd =  VideoCompress.compressVideo(VideoFile.path,quality: VideoQuality.LowQuality);
   print("ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
   print(pickedddd.toString());
  }*/


  FutureOr<void> userClickOnPostBtn(
      UserClickonPostbtn event, Emitter<UserPostStates> emit) async{
    // print("object");
    print(image.toString());
    try{
      print(image.toString());
      if(image != null) {
        emit(LoadingComeState());
        final UserAuth = FirebaseAuth.instance.currentUser;

        String fileName = Path.basename(image!.path);
        log(fileName.toString());

        Reference storageReference = await FirebaseStorage.instance.ref().child('Postimages/$fileName');
        log(storageReference.toString());

        UploadTask uploadTask = storageReference.putFile(image!);
        // Future.delayed(Duration(seconds: 2));
        TaskSnapshot snapshot =await uploadTask;
        log(uploadTask.toString());
        print("4");
        String downloadURL = await snapshot.ref.getDownloadURL();
        print("5");
        print(downloadURL.toString());
        final Firebasesnapshot = await FirebaseFirestore.instance
            .collection("RegisteredUsers").where('uid' ,isEqualTo: UserAuth!.uid).get();
       /* late String Url;
        if (Firebasesnapshot.docs.isNotEmpty) {
          for (var value in Firebasesnapshot.docs) {
            Url = value['profileurl'].toString();
          }
        }*/
        final userdata = Firebasesnapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
        print("6");

        await uploadTask.whenComplete(() async{
          var res = await FirebaseFirestore.instance.collection("UserPost")
              .doc();
           UserPostImageModel userPostImageModel = await UserPostImageModel(Postid: res.id,Username: userdata.Username.toString(), Uid: UserAuth.uid.toString(), Likes: [], PostUrl: downloadURL,datetime: Timestamp.now(),Caption: event.caption,ProfileUrl: event.profileurl,Types: 'image');
              res.set(userPostImageModel.tomap());
        });
        emit(LoadingGoState());
        print("7");
        print('File Uploaded. Download URL: $downloadURL');
        image!.delete();
        emit(AbletoUplaodImage());
      } else {
        emit(UnabletoUplaodImage());
        print('No image to upload.');
      }
    }
    catch(e){
      log(e.toString());
      //   emit(SomeThingWentWrongState);
    }
  }



  Future<void> userVideoPost(UserVideoPost event, Emitter<UserPostStates> emit) async {
   // final pickedddd =  VideoCompress.compressVideo(image!.path,quality: VideoQuality.LowQuality);
    print("ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
    print("Under VIDEOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO PPPPPPPOOOOOOOOOOOOOOOOSSSSSSTTTTTTTTTTTTTTTT");
    print(image.toString());
    try{
      print(image.toString());
      if(image != null) {
        emit(LoadingComeState());
        final UserAuth = FirebaseAuth.instance.currentUser;

        String fileName = Path.basename(image!.path);
        log(fileName.toString());

        Reference storageReference = await FirebaseStorage.instance.ref().child('Postimages/$fileName');
        log(storageReference.toString());

        UploadTask uploadTask = storageReference.putFile(image!);
        // Future.delayed(Duration(seconds: 2));
        TaskSnapshot snapshot =await uploadTask;
        log(uploadTask.toString());
        print("4");
        String downloadURL = await snapshot.ref.getDownloadURL();
        print("5");
        print(downloadURL.toString());
        final Firebasesnapshot = await FirebaseFirestore.instance.collection("RegisteredUsers").where('uid' ,isEqualTo: UserAuth!.uid).get();
        late String Url;
       /* if (Firebasesnapshot.docs.isNotEmpty) {
          for (var value in Firebasesnapshot.docs) {
            Url = value['profileurl'].toString();
          }
        }*/
        final userdata = Firebasesnapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
        print("6");

        await uploadTask.whenComplete(() async{
          var res = await FirebaseFirestore.instance.collection("UserPost").doc();
          UserPostImageModel userPostImageModel = await UserPostImageModel(Postid: res.id,Username: userdata.Username.toString(), Uid: UserAuth.uid.toString(), Likes: [], PostUrl: downloadURL,datetime: Timestamp.now(),Caption: event.caption,ProfileUrl:event.profileurl,Types:'video');
          res.set(userPostImageModel.tomap());
        });
        emit(LoadingGoState());
        print("7");
        print('File Uploaded. Download URL: $downloadURL');
        image!.delete();
        emit(AbletoUplaodImage());
      } else {
        emit(UnabletoUplaodImage());
        print('No image to upload.');
      }
    }
    catch(e){
      log(e.toString());
      //   emit(SomeThingWentWrongState);
    }
  }

  FutureOr<void> userRemoveViedoOrImageEvent(UserRemoveViedoOrImageEvent event, Emitter<UserPostStates> emit) {
   emit(RemovePhotoOrVideoState());
  }
}