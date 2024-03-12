part of 'refresh_bloc.dart';

@immutable
abstract class RefreshState {}

class RefreshInitial extends RefreshState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> Alluserdata;
  RefreshInitial({required this.Alluserdata});
}

class InitState extends RefreshState{

}


class RefreshDoneState extends RefreshState{
  final Stream<QuerySnapshot<Map<String, dynamic>>> RandomData;
final List<DocumentSnapshot> filteredList;
  RefreshDoneState({required this.RandomData,required this.filteredList});

}
