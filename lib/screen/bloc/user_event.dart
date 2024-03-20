import '../../domain/entities/user_entity.dart';

abstract class UserEvent {}

class ImportUsersTableEvent extends UserEvent {
  late final List<User> usersList;
  final isLoading = false;

  ImportUsersTableEvent(this.usersList, isLoading);
}

class GetUsersEvent extends UserEvent {
  late final List<User> usersList;
  final isLoading = false;

  GetUsersEvent(this.usersList, isLoading);
}
