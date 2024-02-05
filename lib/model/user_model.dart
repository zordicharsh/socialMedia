import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? Profileurl;
  String Uid;
  String Username;
  String Email;
  String Password;
  List Following = [];
  List Follower = [];
  Timestamp datetime;
  String? Bio;
  String? Name;

  UserModel(
      {required this.Uid,
      required this.Username,
      required this.Email,
      required this.Password,
      required this.Follower,
      required this.Following,
      required this.datetime,
      required this.Profileurl,
      required this.Bio,
      required this.Name,});

  Map<String, dynamic> toMap() {
    return {
      'uid': Uid,
      'username': Username,
      'email': Email,
      'password': Password,
      'following': Following,
      'follower': Follower,
      'datetime': datetime,
      'profileurl': Profileurl,
      'bio': Bio,
      'name': Name,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      Uid: data["uid"],
      Username: data["username"],
      Email: data["email"],
      Password: data["password"],
      Follower: data["follower"],
      Following: data["following"],
      Profileurl: data["profileurl"],
      datetime: data["datetime"],
      Bio: data["bio"],
      Name: data["name"],
    );
  }
}
