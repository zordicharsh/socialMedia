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
    on<DeleteAccountEvent>(deleteAccountEvent);
  }

  FutureOr<void> publicPrivateEvent(PublicPrivateTrueEvent event, Emitter<DrawerState> emit) {
    bool CheckBloc ;
    if( event.Checking == true)

    {
    CheckBloc = false;
    UserTypesUpdate('public');
    emit(PublicPrivateFaleState(CheckBloc));

    }
    else
    {
    CheckBloc = true;
    UserTypesUpdate('private');
    emit(PublicPrivateTrueState(CheckBloc));
    }
  }

  FutureOr<void> publicPrivateFalseEvent(PublicPrivateFalseEvent event, Emitter<DrawerState> emit) {

  }

  Future<void> UserTypesUpdate(String typess) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if(typess == 'public') {
      await FirebaseFirestore.instance
          .collection('RegisteredUsers')
          .doc(uid)
          .update({
        'acctype': typess,
        'followrequest': [],
        'followrequestnotification': []
      });
    }
    else{
      await FirebaseFirestore.instance
          .collection('RegisteredUsers')
          .doc(uid)
          .update({
        'acctype': typess,
      });
    }
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


  Future<void> deleteAccountEvent(DeleteAccountEvent event, Emitter<DrawerState> emit) async {
    List? Followers;
    List? Following;
    String? Username ;
    String? UID = FirebaseAuth.instance.currentUser?.uid;
    var response =  await  FirebaseFirestore.instance.collection('RegisteredUsers').where('uid',isEqualTo:UID).get();
    for (var value in response.docs) {
      Followers = value['follower'];
      Following = value['following'];
      Username = value['username'];
    }
///// post /////////////
    try{
      await FirebaseFirestore.instance.collection('UserPost').where('uid',isEqualTo:UID).get().then((value) {
        for (var i in value.docs) {
          i.reference.delete();
        }
      },);
    } catch(e){
    }
    ///// comments & Like ////////////////

    DeleteCommentAndLike(UID!, Username!);
    //////////// followers ///////////////////////
    try{
      for( var i = 0 ; i < Followers!.length ; i++) {
        await FirebaseFirestore.instance.collection('RegisteredUsers').doc(Followers[i]).update({'following': FieldValue.arrayRemove([UID])});
      }
    }catch(e){
    }
    //////////////// following ////////////////////////

    try{
      for( var i = 0 ; i < Following!.length ; i++  ) {
        await FirebaseFirestore.instance.collection('RegisteredUsers').doc(Following[i]).update({'follower': FieldValue.arrayRemove([UID])});
      }
    }catch(e){
    }

    try{
      await FirebaseFirestore.instance.collection('RegisteredUsers').doc(UID).delete();
    }catch(e){
    }


  }

  Future<void> DeleteCommentAndLike(String UID,String Username) async {
    await FirebaseFirestore.instance.collection('UserPost').get().then((value) async {
      for (var i in value.docs) {
        String doc = i.id;
        var count = 0;
        /////////// Comments /////////////
        try
        {
          await FirebaseFirestore.instance
              .collection('UserPost')
              .doc(doc)
              .collection('comments')
              .where('username',isEqualTo:Username).get().then((value) {
            for (var i in value.docs) {
              i.reference.delete();
              count++;
            }
            if(count != 0){
              final TotalPost = FirebaseFirestore.instance.collection("UserPost").doc(doc);
              TotalPost.get().then((value) async{
                if (value.exists) {
                  final totalComments = value.get('totalcomments');
                  await  TotalPost.update({"totalcomments": totalComments - count});
                  count = 0;
                }
              });
            }
          },);
        }catch(e){
        }
        ///////////// Like /////////////////
        try{
          final yamama =  await FirebaseFirestore.instance.collection('UserPost').doc(doc).get();
          List arrLike = yamama.get("likes");
          final totallikes = yamama.get("totallikes");
          if(arrLike.contains(UID)){
            await FirebaseFirestore.instance.collection('UserPost').doc(doc).update({
              "likes": FieldValue.arrayRemove([UID]),
              "totallikes": totallikes - 1,
            });
          }
        }catch (e){
        }
      }
    },);
  }

}