import 'package:bloc/bloc.dart';
import 'package:students_db/screen/bloc/user_event.dart';
import 'package:students_db/screen/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(users: List.empty(), isLoading: true)) {
    on<ImportUsersTableEvent>((event, emit) => emit(
        state.copyWith(users: event.usersList, isLoading: event.isLoading)));
    on<GetUsersEvent>((event, emit) => emit(
        state.copyWith(users: event.usersList, isLoading: event.isLoading)));
  }
}
