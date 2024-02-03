import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/screens/profile/ui/profile.dart';
import 'login/loginui.dart';
class splservice{


  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser?.uid;
    if (auth != null) {
      Timer(const Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
      );
    }
    else {
      print(auth.toString());
      Timer(const Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginUi())),
      );
    }
  }
}