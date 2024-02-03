import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String username;
  String email;
  String password;
  List following = [];
  List follower = [];
  Timestamp datetime;
  String? profileImage;
  String? name
  ;

UserModel({required this.uid,required this.username,required this.email,required this.password,required this.following,required this.follower,required this.datetime,required this.profileImage,required this.name});

// sending data to firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'password': password,
      'following': following,
      'follower': follower,
      'datetime': datetime,
      'profileurl':profileImage,
      'name':name
    };
  }

  //fetching user data from firebase
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        uid: data["uid"],
        username: data["username"],
        email: data["email"],
        password: data["password"],
        follower: List.from(data["follower"]),
        following: List.from(data["following"]),
        datetime: data["datetime"],
      profileImage:data["profileurl"],
        name: data["name"]
    );
  }
}
