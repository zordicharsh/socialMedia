import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_event.dart';
import 'login_state.dart';
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitailState()) {
    on<VisibilityButtonEvent>(visibilityButtonEvent);
    on<LoginValidationError>(loginValidationError);
  }
  FutureOr<void> visibilityButtonEvent(
      VisibilityButtonEvent event, Emitter<LoginState> emit) {
    if (event.visi == true) {
      print("true");
      emit(VisibilityTrueState());
    } else {
      print("kuchnahi");
      emit(VisibilityFalseState());
    }
  }

  Future<void> loginValidationError(LoginValidationError event, Emitter<LoginState> emit) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.Email.trim(),
        password: event.Password.trim(),
      );
      print("Login successful");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("User not found");
      } else if (e.code == 'wrong-password') {
        print("Wrong password");
      }
    }
  }}
