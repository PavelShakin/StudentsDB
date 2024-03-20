import 'package:equatable/equatable.dart';
import 'package:students_db/domain/entities/user_entity.dart';

class UserState extends Equatable {
  final List<User> users;
  final bool isLoading;

  const UserState({required this.users, required this.isLoading});

  @override
  List<Object> get props => [users, isLoading];

  UserState copyWith({List<User>? users, bool? isLoading}) {
    return UserState(
        users: users ?? this.users, isLoading: isLoading ?? this.isLoading);
  }
}
