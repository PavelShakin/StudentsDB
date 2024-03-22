import 'package:students_db/data/database/sqlite_service.dart';

import '../../domain/entities/user_entity.dart';

abstract class UserEvent {}

class GetUsersEvent extends UserEvent {
  late final List<User> usersList;
  final isLoading = false;

  GetUsersEvent(this.usersList, isLoading);
}

class OnFileSelected extends UserEvent {
  late final String filePath;
  final SqliteService sqliteService;

  OnFileSelected(this.filePath, this.sqliteService);
}

class CallPhoneNumber extends UserEvent {
  late final String phoneNumber;

  CallPhoneNumber(this.phoneNumber);
}