
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RequestState {}

class RequestInitial extends RequestState {}

class RequestFollowerDataState extends RequestState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> postdata;
  RequestFollowerDataState(this.postdata);

}
