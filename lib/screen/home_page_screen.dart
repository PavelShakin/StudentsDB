import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:searchfield/searchfield.dart';
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
  FilePickerResult? result;
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
      await Permission.storage.request();
      await _getUsers();
    });
  }

  Future<void> _getUsers() async {
    final result = await _sqliteService.getUsersList();
    dispatchEvent(context, GetUsersEvent(result, false));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () async {
                result =
                    await FilePicker.platform.pickFiles(allowMultiple: false);
                if (result != null) {
                  dispatchEvent(
                      context,
                      OnFileSelected(
                          result!.files.first.path ?? '', _sqliteService));
                }
              },
              child: const Text("Select file"),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.users.isNotEmpty
                    ? Column(children: [
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SearchField<User>(
                            suggestions: state.users
                                .map(
                                  (e) => SearchFieldListItem<User>(
                                    e.fullName,
                                    item: e,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(e.fullName),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            searchStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.8),
                            ),
                            searchInputDecoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ),
                            itemHeight: 50,
                            hint: 'Search student by name',
                            maxSuggestionsInViewPort: 2,
                            emptyWidget: const Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Center(child: Text('No students found')),
                            ),
                            onSuggestionTap: (SearchFieldListItem<User> user) {
                              dispatchEvent(context, CallPhoneNumber(user.item!.phoneNumber));
                            },
                          ),
                        ),
                        const SizedBox(height: 50),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8),
                            itemCount: state.users.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  dispatchEvent(context, CallPhoneNumber(state.users[index].phoneNumber));
                                },
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      state.users[index].fullName,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.none,
                                          fontSize: 20),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                          ),
                        )
                      ])
                    : const Center(
                        child: Text('Users list is empty'),
                      );
          },
        ),
      ),
    );
  }
}
