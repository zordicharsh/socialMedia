import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_event.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvents,RegistrationStaste>{

  RegistrationBloc() : super(RegistrationInitalState()){
    //init of ClickOnSignup and Signin Button
    on<ClickOnSignUpButton>(clickOnSignupButton);
    on<ClickOnSigninButton>(clickOnSigninButton);
  }



  //methods of RegistrationBloc

  FutureOr<void> clickOnSignupButton(ClickOnSignUpButton event, Emitter<RegistrationStaste> emit) {

  }

  FutureOr<void> clickOnSigninButton(ClickOnSigninButton event, Emitter<RegistrationStaste> emit) {


  }
}