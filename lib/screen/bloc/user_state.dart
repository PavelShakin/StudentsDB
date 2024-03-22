import 'package:equatable/equatable.dart';
import 'package:students_db/domain/entities/user_entity.dart';

class UserState extends Equatable {
  final List<User> users;
  final String filePath;
  final bool isLoading;

  const UserState({required this.users, required this.filePath, required this.isLoading});

  @override
  List<Object> get props => [users, filePath, isLoading];

  UserState copyWith({List<User>? users, String? filePath, bool? isLoading}) {
    return UserState(
        users: users ?? this.users, filePath: filePath ?? this.filePath, isLoading: isLoading ?? this.isLoading);
  }
}
