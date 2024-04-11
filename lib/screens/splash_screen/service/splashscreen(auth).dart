import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/navigation_handler/ui/navigation.dart';

import '../../login/ui/loginui.dart';

class splservice {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser?.uid;
    if (auth != null) {
      BlocProvider.of<GlobalBloc>(context).add(GetUserIDEvent(uid: auth));
      Timer(
        const Duration(milliseconds: 1900),
        () => Navigator.pushReplacement(context,
            CustomPageRouteRightToLeft(child: const LandingPage())),
      );
    } else {
      Timer(
        const Duration(milliseconds: 1900),
        () => Navigator.pushReplacement(
            context, CustomPageRouteRightToLeft(child: const LoginUi())),
      );
    }
  }
}
