import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SearchState {}

class SearchInitState extends SearchState{}


class EmittheUSers extends SearchState{
  List users;
  final Stream<QuerySnapshot<Map<String, dynamic>>> UserLists;
  EmittheUSers(this.users,this.UserLists);
}

class NouserAvailable extends SearchState{}

