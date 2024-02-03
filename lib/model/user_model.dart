import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String Name;
  String ?Profileurl;
  String Uid;
  String Username;
  String Email;
  String Password;
  List Following = [];
  List Follower = [];
  Timestamp datetime;

  UserModel(
      {required this.Name,required this.Uid, required this.Username, required this.Email, required this.Password,
        required this.Follower, required this.Following, required this.datetime ,this.Profileurl});

  Map<String, dynamic> toMap() {
    return {
      'name':Name,
      'uid': Uid,
      'username': Username,
      'email': Email,
      'password': Password,
      'following': Following,
      'follower': Follower,
      'datetime': datetime,
      'profileurl':Profileurl
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel(
        Name: data["name"],
        Uid: data["uid"],
        Username: data["username"],
        Email: data["email"],
        Password: data["password"],
        Follower: data["follower"],
        Following: data["following"],
        Profileurl: data["profileurl"],
        datetime: data["datetime"]);
  }


}
