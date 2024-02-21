part of 'global_bloc.dart';

@immutable
abstract class GlobalState {}

class GlobalInitial extends GlobalState {}

class GetUserDataFromGlobalBlocState extends GlobalState {
  final List<UserModel> userData;

  GetUserDataFromGlobalBlocState(this.userData);
}
