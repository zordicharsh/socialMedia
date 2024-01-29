import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_event.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_state.dart';
import 'package:socialmedia/screens/registration/registrationmodel/registrationmodel.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStates> {
  RegistrationBloc() : super(RegistrationInitalState()) {
    //init of ClickOnSignup and Signin Button
    on<ClickOnVisibilityButton>(clickOnLightButton);
    on<ClickOnSignUpButton>(clickOnSignUpButton);
  }

  FutureOr<void> clickOnLightButton(
      ClickOnVisibilityButton event, Emitter<RegistrationStates> emit) {
    if (event.Obsecure == true) {
      emit(obsecureTrue(Obsecure: false));
    } else {
      emit(obsecureFalse(Obsecure: true));
    }
  }

  FutureOr<void> clickOnSignUpButton(
      ClickOnSignUpButton event, Emitter<RegistrationStates> emit) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('RegisteredUsers');
      QuerySnapshot querySnapshot = await users
          .where('username', isEqualTo: event.Username.toString())
          .get();
      print(querySnapshot.docs);
      // String ?gloable;
      // String ?password;
      // querySnapshot.docs.forEach((data) {
      //   if (data['username'].toString().isEmpty) {
      //   } else {
      //     gloable = data['username'].toString();
      //     password = data['password'].toString();
      //   }
      // });
      // print(gloable.toString());
      // print(password.toString());

      if (querySnapshot.docs.isEmpty) {
        final UserAuth = FirebaseAuth.instance.currentUser;
        final UserCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: event.Email.trim(), password: event.Password.trim());
        emit(AuthSuccessLoading());
        DateTime now = DateTime.now();
        RegistrationModel RegModel = RegistrationModel(
            UserAuth!.uid.toString(),
            event.Username.trim(),
            event.Email.trim(),
            event.Password.trim(),
            [],
            [],
            now);
        var res = await FirebaseFirestore.instance
            .collection("RegisteredUsers")
            .doc(UserAuth.uid.toString())
            .set(RegModel.toMap());
        emit(FirebaseAuthSuccessState(AuthSuccessMessage: "Loginpage load"));
        emit(AuthSuccessLoading());
        emit(NavigateToLoginScreen());
      } else {
        emit(
            FirebaseAuthErrorState(AuthErrorMessage: "Username already exits"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(FirebaseAuthErrorState(AuthErrorMessage: "Weak password"));
      } else if (e.code == 'email-already-in-use') {
        emit(FirebaseAuthErrorState(AuthErrorMessage: "email already in use"));
      }
    } catch (e) {
      emit(FirebaseAuthErrorState(AuthErrorMessage: e.toString()));
    }
  }
}
