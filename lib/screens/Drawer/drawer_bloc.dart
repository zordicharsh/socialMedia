import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'drawer_event.dart';
import 'drawer_state.dart';



class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(DrawerInitial()) {
    on<PublicPrivateTrueEvent>(publicPrivateEvent);
    on<PublicPrivateFalseEvent>(publicPrivateFalseEvent);
    on<SignOutEvent>(signOutEvent);
    on<FirstCheckAccTypeEvent>(firstCheckAccTypeEvent);
  }

  FutureOr<void> publicPrivateEvent(PublicPrivateTrueEvent event, Emitter<DrawerState> emit) {
    bool CheckBloc ;
    if( event.Checking == true)

      {    print("Checking ====      True");
        CheckBloc = false;
      UserTypesUpdate('public');
      emit(PublicPrivateFaleState(CheckBloc));

      }
    else
        {  print("Checking ====      False");
        CheckBloc = true;
          UserTypesUpdate('private');
        emit(PublicPrivateTrueState(CheckBloc));
        }
  }

  FutureOr<void> publicPrivateFalseEvent(PublicPrivateFalseEvent event, Emitter<DrawerState> emit) {

  }

  Future<void> UserTypesUpdate(String typess) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(uid)
        .update({
       "acctype": typess
    });
    UdateAcctypeInPostCollection(typess);
  }
  void UdateAcctypeInPostCollection(String Typesss) async {
    await FirebaseFirestore.instance
        .collection('UserPost')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get().then((value) {
      for (var i in value.docs) {
        i.reference.update({'acctype': Typesss});
      }
    },
    );
  }

  FutureOr<void> signOutEvent(
      SignOutEvent event, Emitter<DrawerState> emit) async {
    var auth = FirebaseAuth.instance;
    await auth.signOut();
    emit(SignOutState());
  }

  Future<void> firstCheckAccTypeEvent(FirstCheckAccTypeEvent event, Emitter<DrawerState> emit) async {
    String? TypessCheck;
    bool check;
   var response =  await  FirebaseFirestore.instance.collection('RegisteredUsers').where('uid',isEqualTo:FirebaseAuth.instance.currentUser?.uid).get();
     for (var value in response.docs) {
       TypessCheck = value['acctype'].toString();
     }
     if( TypessCheck == 'private'){
       check = true;
       emit(PublicPrivateTrueState(check));
     }

}

}
