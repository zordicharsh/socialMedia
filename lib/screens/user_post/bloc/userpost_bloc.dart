import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  }

  File? image;
  final picker = ImagePicker();
  FutureOr<void> userUploadImagebtn(
      UsergetImage event, Emitter<UserPostStates> emit) async{
    print("object");
    final pickedFile = await picker.pickImage(imageQuality: 50,source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(SuccessFullySelectedImage(image));
      // print(image);
    } else {
      emit(UnSuccessFullySelectedImage());
    }
  }

  FutureOr<void> userClickOnPostBtn(
      UserClickonPostbtn event, Emitter<UserPostStates> emit) async{
    // print("object");
    print(image.toString());
    try{
      print(image.toString());
      if(image != null) {
        emit(LoadingComeState());
        final UserAuth = FirebaseAuth.instance.currentUser;
        print("1");
        String fileName = Path.basename(image!.path);
        log(fileName.toString());
        print("2");
        Reference storageReference =
        await FirebaseStorage.instance.ref().child('Postimages/$fileName');
        log(storageReference.toString());
        print("3");
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
          UserPostImageModel userPostImageModel = await UserPostImageModel(Postid: res.id,Username: userdata.Username.toString(), Uid: UserAuth.uid.toString(), Likes: [], PostUrl: downloadURL,datetime: Timestamp.now(),Caption: event.caption,ProfileUrl: event.profileurl);
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
}