import 'package:flutter/material.dart';
import 'package:fluttermin/api.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:fluttermin/models/user.dart';
import 'package:fluttermin/pages/authorized_page.dart';
import 'package:provider/provider.dart';

class AppUsersPage extends StatelessWidget {
  const AppUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthorizedPage(
      key: key,
      title: Text('Users'),
      body: Consumer<AppModel>(
        builder: (BuildContext context, AppModel model, Widget? _) {
          return FutureBuilder(
            future: Api.users(model.user!.jwt),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _buildUserList(
                  context,
                  snapshot.hasData ? snapshot.data : [],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildUserList(BuildContext context, List<User> users) {
    List<MapEntry<String, bool>> colcfg = [
      MapEntry('ID', true),
      MapEntry('Last name', false),
      MapEntry('First name', false),
      MapEntry('Email', false),
      MapEntry('Role', false),
    ];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DataTable(
        sortAscending: true,
        sortColumnIndex: 1,
        headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
        columns: colcfg
            .map((cc) => DataColumn(label: Text(cc.key), numeric: cc.value))
            .toList(),
        rows: users
            .map(
              (u) => DataRow(
                cells: [
                  DataCell(Text('${u.id}')),
                  DataCell(Text(u.lastName)),
                  DataCell(Text(u.firstName)),
                  DataCell(Text(u.email)),
                  DataCell(Text(u.role)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
