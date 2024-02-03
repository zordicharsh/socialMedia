import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<VisibilityButtonEvent>(visibilityButtonEvent);
    on<LoginValidationError>(loginValidationError);
  }
  ////////////////////////////////////////////////////////////    OBESCURED  METHOD/////////////////////////////////////////////////////
  FutureOr<void> visibilityButtonEvent(
      VisibilityButtonEvent event, Emitter<LoginState> emit) {
    if (event.visibility == true) {
      //  print("true");
      emit(VisibilityTrueState(Obsecure: false));
    } else {
      // print("kuchen");
      emit(VisibilityFalseState(Obsecure: true));
    }
  }
  //////////////////////////////////////////////////////////////// LOGIN  METHOD ///////////////////////////////////////////////////////////
  Future<void> loginValidationError(
      LoginValidationError event, Emitter<LoginState> emit) async {
    if (RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(event.Email)) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.Email.trim(),
          password: event.Password.trim(),
        );
        emit(LoginLoadingSuccessState());
        emit(LoginSuccessState(uid: userCredential.user!.uid));
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
      /////////////////////////////////////////////////  UserName //////////////////////////////////////////////////
      try {
        var response = await FirebaseFirestore.instance
            .collection('RegisteredUsers')
            .where('username', isEqualTo: event.Email.trim())
            .get();
        late String pas;
        late String use;
        late String UseEmail;
        late String uid;
        //  print("its all goo men");
        if (response.docs.isNotEmpty) {
          for (var value in response.docs) {
            use = value['username'].toString();
            pas = value['password'].toString();
            UseEmail =value['email'].toString();
            uid =value['uid'].toString();
          }
        }
        if (event.Email != use || event.Password != pas) {
          emit(LoginValidationErrorState(message: "Wrong Password"));
        } else {
          UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: UseEmail,
            password: pas,
          );
          emit(LoginLoadingSuccessState());
          emit(LoginSuccessState(uid: uid));
        }
      } catch (e) {
        emit(LoginValidationErrorState(message: "User Not Found"));
      }
    }
  }
}
