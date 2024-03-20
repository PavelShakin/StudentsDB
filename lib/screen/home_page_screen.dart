import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:students_db/data/database/sqlite_service.dart';
import 'package:students_db/screen/bloc/user_bloc.dart';
import 'package:students_db/screen/bloc/user_state.dart';

import 'bloc/user_event.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  final List<String> entries = <String>['A', 'B', 'C'];
  late SqliteService _sqliteService;

  void dispatchEvent(BuildContext context, UserEvent event) {
    context.read<UserBloc>().add(event);
  }

  @override
  void initState() {
    super.initState();
    _sqliteService = SqliteService();
    _sqliteService.initializeDB().whenComplete(() async {
      await _getUsers();
    });
  }

  Future<void> _getUsers() async {
    final result = await _sqliteService.getUsersList();
    dispatchEvent(context, GetUsersEvent(result, false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Directionality(
            textDirection: TextDirection.ltr,
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      const SizedBox(height: 100),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: entries.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              child: Center(
                                child: Text(
                                  '${state.users.length}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: 24),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
                    ],
                  ));
      },
    );
  }
}
