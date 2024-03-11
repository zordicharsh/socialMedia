import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  ExploreBloc() : super(ExploreInitial()) {
    on<UserClickOnLikedBtn>(userClickOnLikedBtn);
  }

  FutureOr<void> userClickOnLikedBtn(UserClickOnLikedBtn event, Emitter<ExploreState> emit) {
    if(event.getlikestate == true){
      print(event.getlikestate.toString());
      emit(showliking(false));
    }else{
      print(event.getlikestate.toString());
      emit(showliking(true));
    }
  }
}
