import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/navigation_handler/navigation.dart';

import 'login/loginui.dart';

class splservice {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser?.uid;
    if (auth != null) {
      BlocProvider.of<GlobalBloc>(context).add(GetUserIDEvent(uid: auth));
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LandingPage())),
      );
    } else {
      print(auth.toString());
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginUi())),
      );
    }
  }
}
