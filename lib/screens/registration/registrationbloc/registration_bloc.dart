import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_event.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStaste> {
  RegistrationBloc() : super(RegistrationInitalState()) {
    //init of ClickOnSignup and Signin Button
    on<ClickOnSignUpButton>(clickOnSignupButton);
    on<ClickOnSigninButton>(clickOnSigninButton);
  }



  FutureOr<void> clickOnSignupButton(
      ClickOnSignUpButton event, Emitter<RegistrationStaste> emit) {
    if (event.Username.isEmpty) {
      emit(RegistrationValidationErrorState(DynmaicError: "Enter a username"));
    }else if(event.Username.isNotEmpty){
      emit(RegistrationValidationSuccessState());
    }

    if (event.Email.isEmpty) {
      print("Please enter Email");
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(event.Email)) {
      print("Enter Email in correct form");
    }

    if (event.Password.isEmpty) {
      print("Enter password of user");
    } else if (event.Password.length < 8) {
      print("Password length is less than 8");
    }

    if (event.ConfromPassword.isEmpty) {
      print("Confirm password is Empty");
    } else if (event.ConfromPassword.length < 8) {
      print("Confirm password length is less than 8");
    }

    if (event.Password != event.ConfromPassword) {
      print("Both Password fields do not match");
    }

    if (event.Username.isNotEmpty &&
        event.Email.isNotEmpty &&
        RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
            .hasMatch(event.Email) &&
        event.Password.isNotEmpty &&
        event.ConfromPassword.isNotEmpty &&
        event.Password == event.ConfromPassword &&
        event.Password.length >= 8 &&
        event.ConfromPassword.length >= 8) {
      print("Checking auth");
    }
  }

  FutureOr<void> clickOnSigninButton(
      ClickOnSigninButton event, Emitter<RegistrationStaste> emit) {}
}
