import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:students_db/data/database/sqlite_service.dart';
import 'package:students_db/domain/entities/user_entity.dart';
import 'package:students_db/screen/bloc/user_bloc.dart';
import 'package:students_db/screen/bloc/user_state.dart';

import 'bloc/user_event.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageScreen> {
  final List<User> users = <User>[
    User(fullName: 'Bob', userGroup: 'B1', phoneNumber: '+380950956949'),
    User(fullName: 'Jim', userGroup: 'B2', phoneNumber: '+380950956948'),
    User(fullName: 'Jacob', userGroup: 'A0', phoneNumber: '+380950956947')
  ];
  late SqliteService _sqliteService;

  void dispatchEvent(BuildContext context, UserEvent event) {
    context.read<UserBloc>().add(event);
  }

  @override
  void initState() {
    super.initState();
    _sqliteService = SqliteService();
    _sqliteService.initializeDB().whenComplete(() async {
      await _mockUsers();
      await _getUsers();
    });
  }

  Future<void> _mockUsers() async {
    var res = await Permission.storage.request();
    if (res.isGranted) {
      ByteData byteData = await rootBundle.load('assets/Book.xlsx');
      List<int> bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      _sqliteService.readExcelData(bytes);
    }

    // for (var user in users) {
    //   _sqliteService.insertUser(user);
    // }
  }

  Future<void> _deleteTable() async {
    _sqliteService.deleteTable();
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
                : state.users.isNotEmpty
                    ? Column(
                        children: [
                          const SizedBox(height: 100),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(8),
                              itemCount: state.users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  child: Center(
                                    child: Text(
                                      state.users[index].fullName,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                          fontSize: 24),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: Text('Users list is empty'),
                      ));
      },
    );
  }
}
