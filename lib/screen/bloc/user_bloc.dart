import 'package:bloc/bloc.dart';
import 'package:students_db/domain/entities/user_entity.dart';
import 'package:students_db/screen/bloc/user_event.dart';
import 'package:students_db/screen/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState(users: List.empty(), isLoading: true)) {
    on<ImportUsersTableEvent>((event, emit) => emit(
        state.copyWith(users: event.usersList, isLoading: event.isLoading)));
    on<GetUsersEvent>((event, emit) => emit(
        state.copyWith(users: event.usersList, isLoading: event.isLoading)));
    on<OnFileSelected>((event, emit) async {
      await event.sqliteService.deleteTable();
      final List<List<String>> users = await event.sqliteService.readExcelData(event.filePath);
      for (var user in users) {
        event.sqliteService.insertUser(
          User(fullName: user[0], userGroup: user[1], phoneNumber: user[2])
        );
      }
      final updatedUsersList = await event.sqliteService.getUsersList();
      emit(state.copyWith(users: updatedUsersList));
    });
  }
}
