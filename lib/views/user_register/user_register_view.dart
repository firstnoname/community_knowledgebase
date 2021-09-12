import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_register_bloc.dart';

class UserRegisterView extends StatelessWidget {
  UserRegisterView({Key? key}) : super(key: key);

  final _formGK = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[200],
      ),
      body: BlocProvider<UserRegisterBloc>(
        create: (ctx) => UserRegisterBloc(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width / 3, vertical: 48),
          color: Colors.green[50],
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.yellow[100]!, Colors.green[100]!],
                ),
              ),
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(24),
              child: BlocBuilder<UserRegisterBloc, UserRegisterState>(
                builder: (ctx, state) {
                  return Form(
                    key: _formGK,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildTextFieldEmail(ctx),
                          buildTextFieldDisplayName(ctx),
                          // buildSelectProvince(ctx),
                          // buildSelectDistrict(ctx),
                          // buildSelectSubDistrict(ctx),
                          buildTextFieldPassword(ctx),
                          buildTextFieldPasswordConfirm(ctx),

                          buildButtonSignUp(ctx)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildButtonSignUp(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 50),
      child: GestureDetector(
        child: Text(
          "Sign up",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        onTap: () async {
          if (!_formGK.currentState!.validate()) {
            return;
          }
          context.read<UserRegisterBloc>().add(UserSubmittedForm());
          _formGK.currentState!.save();
        },
        // onTap: () => context.read<UserRegisterBloc>().add(UserSubmittedForm()),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: Colors.green[200]),
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(12),
    );
  }

  Container buildTextFieldEmail(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        decoration: InputDecoration.collapsed(hintText: "Email"),
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 18),
        onSaved: (value) =>
            BlocProvider.of<UserRegisterBloc>(context).email = value,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter some text';
        },
      ),
    );
  }

  Container buildTextFieldDisplayName(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        obscureText: false,
        decoration: InputDecoration.collapsed(hintText: "Display name"),
        style: TextStyle(fontSize: 18),
        onSaved: (value) =>
            BlocProvider.of<UserRegisterBloc>(context).displayName = value,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter some text';
        },
      ),
    );
  }

  Container buildSelectProvince(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: DropdownButton(
        items: [],
      ),
    );
  }

  Container buildTextFieldPassword(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration.collapsed(hintText: "Password"),
        style: TextStyle(fontSize: 18),
        onSaved: (value) =>
            BlocProvider.of<UserRegisterBloc>(context).password = value,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter some text';
        },
      ),
    );
  }

  Container buildTextFieldPasswordConfirm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration.collapsed(hintText: "Re-password"),
        style: TextStyle(fontSize: 18),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter some text';
        },
      ),
    );
  }
}
