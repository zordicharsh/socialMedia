import 'dart:async';
import 'dart:math';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_event.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_state.dart';
import 'package:socialmedia/screens/registration/registrationmodel/registrationmodel.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStaste> {
  RegistrationBloc() : super(RegistrationInitalState()) {
    //init of ClickOnSignup and Signin Button
    on<ClickOnLightButton>(clickOnLightButton);
    on<ClickOnSignUpButton>(clickOnSignUpButton);
  }

  FutureOr<void> clickOnLightButton(ClickOnLightButton event, Emitter<RegistrationStaste> emit) {
    if(event.Obsecure == true){
      emit(obsecureTrue(Obsecure: false));
    }else {emit(obsecureFalse(Obsecure: true));
    }
  }

  FutureOr<void> clickOnSignUpButton(ClickOnSignUpButton event, Emitter<RegistrationStaste> emit) async{

    try{
      final UserAuth = FirebaseAuth.instance.currentUser;
      final UserCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: event.Email.trim(), password: event.Password.trim());
      DateTime now = DateTime.now();
      print(now); // Output: 2023-01-23 14:30:45.123456
      RegistrationModel RegModel=RegistrationModel(UserAuth!.uid.toString(),event.Username.trim(), event.Email.trim(), event.Password.trim(),[],[],now);
      var res=await FirebaseFirestore.instance.collection("RegisteredUsers").doc(UserAuth.uid.toString()).set(RegModel.toMap());
       emit(AuthSuccessLoading());
      await  Future.delayed(Duration(seconds: 4));
      emit(FirebaseAuthSuccessState(AuthSuccessMessage: "Loginpage load"));

      emit(NavigateToLoginScreen());
    }on FirebaseAuthException catch(e){
      if (e.code == 'weak-password') {
        emit(FirebaseAuthErrorState(AuthErrorMessage: "Weak password"));
      }
      else if(e.code == 'email-already-in-use'){
        emit(FirebaseAuthErrorState(AuthErrorMessage: "email already in use"));
      }

    }catch(e){
      emit(FirebaseAuthErrorState(AuthErrorMessage: "somthing went wrong"));
    }





  }
}
