part of 'global_bloc.dart';

@immutable
abstract class GlobalEvent {}

class GetUserIDEvent extends GlobalEvent {
  final String? uid;
  GetUserIDEvent({required this.uid});
}