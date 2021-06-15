import 'package:flutter/material.dart';
import 'package:fluttermin/models/user.dart';
import 'package:fluttermin/pages/a_page.dart';
import 'package:provider/provider.dart';
import 'package:fluttermin/api.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:fluttermin/models/auth.dart';
import 'package:fluttermin/models/app_error.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return APage(
      key: widget.key,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              width: 480,
              child: Form(
                key: _formKey,
                child: Consumer<AppModel>(
                  builder: (BuildContext ctx, AppModel model, Widget? w) {
                    return Column(
                      children: <Widget>[
                        TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (v) => v != null && v.isEmpty
                              ? 'Email is required'
                              : null,
                          onSaved: (v) => model.credentials.email = v ?? '',
                        ),
                        TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(labelText: 'Password'),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          textCapitalization: TextCapitalization.none,
                          validator: (v) => v != null && v.isEmpty
                              ? 'Password is required'
                              : null,
                          onSaved: (v) => model.credentials.pass = v ?? '',
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                var ctrl = Scaffold.of(context).showBottomSheet(
                                    (context) =>
                                        Text('Sending credentials ...'));
                                Jwt jwt = await Api.login(model.credentials);
                                Claims c = await Api.claims(jwt);
                                model.user = User(jwt, c);
                                ctrl.close();
                              } catch (e) {
                                Scaffold.of(context).showBottomSheet(
                                    (context) => Text((e as AppError).message));
                              }
                            }
                          },
                          child: Text('Sign in'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
