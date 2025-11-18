import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class SessionState extends Equatable {
  const SessionState({required this.guidedMode});

  final bool guidedMode;

  SessionState copyWith({bool? guidedMode}) {
    return SessionState(guidedMode: guidedMode ?? this.guidedMode);
  }

  @override
  List<Object?> get props => [guidedMode];
}

abstract class SessionEvent {}

class ToggleGuidedMode extends SessionEvent {}

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(const SessionState(guidedMode: true)) {
    on<ToggleGuidedMode>((event, emit) {
      emit(state.copyWith(guidedMode: !state.guidedMode));
    });
  }
}
