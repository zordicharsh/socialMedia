import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitailState()) {
    on<VisibilityButtonEvent>(visibilityButtonEvent);
    on<LoginValidationError>(loginValidationError);
  }

  ////////////////////////////////////////////////////////////      OBESCURED  METHOD/////////////////////////////////////////////////////
  FutureOr<void> visibilityButtonEvent(
      VisibilityButtonEvent event, Emitter<LoginState> emit) {
    if (event.visibility == true) {
      //  print("true");
      emit(VisibilityTrueState());
    } else {
      // print("kuchnahi");
      emit(VisibilityFalseState());
    }
  }

  //////////////////////////////////////////////////////////////// LOGIN  METHOD ///////////////////////////////////////////////////////////
  Future<void> loginValidationError(
      LoginValidationError event, Emitter<LoginState> emit) async {
    if (RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(event.Email)) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.Email.trim(),
          password: event.Password.trim(),
        );
        emit(LoginLoadingSuccessState());
        emit(LoginSuccessState());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(LoginValidationErrorState(
              message: "User Not Found For That Email "));
        } else if (e.code == 'wrong-password') {
            //print("Wrong password");
          emit(LoginValidationErrorState(message: "Wrong Password"));
        }
      }
    } else {
      try {
        var response = await FirebaseFirestore.instance
            .collection('RegisteredUsers')
            .where('username', isEqualTo: event.Email.trim())
            .get();
        late String pas;
        late String use;
        //  print("its all goo men");
        if (response.docs.isNotEmpty) {
          for (var value in response.docs) {
            use = value['username'].toString();
            pas = value['password'].toString();
          }
        }
        //  print(use.toString());
        //  print(pas.toString());
        if (event.Email != use || event.Password != pas) {
          emit(LoginValidationErrorState(message: "Wrong Password"));
        } else {
          emit(LoginLoadingSuccessState());
          emit(LoginSuccessState());
        }
      } catch (e) {
        emit(LoginValidationErrorState(message: "User Not Found"));
      }
    }
  }
}
