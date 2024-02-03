import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial(tabindex: 0)) {
    on<NavigationInitialEvent>(navigationInitialEvent);
  on<TabChangedEvent>(tabChangedEvent);
  }

  FutureOr<void> tabChangedEvent(TabChangedEvent event, Emitter<NavigationState> emit) {
    emit(NavigationInitial(tabindex: event.tabIndex));
  }

  FutureOr<void> navigationInitialEvent(NavigationInitialEvent event, Emitter<NavigationState> emit) {
    emit(NavigationInitial(tabindex: event.tabIndex));
  }
}
