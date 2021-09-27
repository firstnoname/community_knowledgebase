import 'package:community_knowledgebase/models/address/base_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_register_bloc.dart';

class UserRegisterView extends StatefulWidget {
  UserRegisterView({Key? key}) : super(key: key);

  @override
  _UserRegisterViewState createState() => _UserRegisterViewState();
}

class _UserRegisterViewState extends State<UserRegisterView> {
  final _formGK = GlobalKey<FormState>();

  // var testItems = [
  //   'Apple',
  //   'Banana',
  //   'Grapes',
  //   'Orange',
  //   'watermelon',
  //   'Pineapple'
  // ];

  // String dropdownvalue = 'Apple';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up", style: TextStyle(color: Colors.white)),
      ),
      body: BlocProvider<UserRegisterBloc>(
        create: (context) => UserRegisterBloc(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width / 3, vertical: 48),
          color: Colors.green[50],
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
                // gradient: LinearGradient(
                //   colors: [Colors.yellow[100]!, Colors.green[100]!],
                // ),
              ),
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(24),
              child: BlocBuilder<UserRegisterBloc, UserRegisterState>(
                builder: (context, state) {
                  return Form(
                    key: _formGK,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buildTextFieldEmail(context),
                          buildTextFieldDisplayName(context),
                          buildSelectProvince(context),
                          buildSelectDistrict(context),
                          buildSelectSubDistrict(context),
                          buildTextFieldPassword(context),
                          buildTextFieldPasswordConfirm(context),
                          buildButtonSignUp(context)
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

  Container buildSelectSubDistrict(BuildContext context) {
    List<BaseAddress> subDistrictItems;
    BaseAddress currentSubDistrict;

    return Container(
      child: BlocBuilder<UserRegisterBloc, UserRegisterState>(
        buildWhen: (previous, current) {
          if (current is UserRegisterStateGetSubDistrictSuccess)
            return true;
          else
            return false;
        },
        builder: (context, state) {
          if (state is UserRegisterStateGetSubDistrictSuccess) {
            subDistrictItems = state.subDistrictList;
            currentSubDistrict = state.currentSubDistrict;
            return subDistrictItems.length == 0
                ? Container()
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        borderRadius: BorderRadius.circular(16)),
                    child: DropdownButton<BaseAddress>(
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: currentSubDistrict,
                      items: subDistrictItems
                          .map(
                            (e) => DropdownMenuItem<BaseAddress>(
                              value: e,
                              child: Text('${e.name}'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        context.read<UserRegisterBloc>().add(
                              UserRegisterEventPressSubDistrict(value!),
                            );
                      },
                    ),
                  );
          } else
            return Container();
        },
      ),
    );
  }

  Container buildSelectDistrict(BuildContext context) {
    List<BaseAddress> districtItems;
    BaseAddress currentDistrict;

    return Container(
      child: BlocBuilder<UserRegisterBloc, UserRegisterState>(
        buildWhen: (previous, current) {
          if (current is UserRegisterStateGetDistrictSuccess)
            return true;
          else
            return false;
        },
        builder: (context, state) {
          if (state is UserRegisterStateGetDistrictSuccess) {
            districtItems = state.districtList;
            currentDistrict = state.currentDistrict;
            return districtItems.length == 0
                ? Container()
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        borderRadius: BorderRadius.circular(16)),
                    child: DropdownButton<BaseAddress>(
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: currentDistrict,
                      items: districtItems
                          .map(
                            (e) => DropdownMenuItem<BaseAddress>(
                              value: e,
                              child: Text('${e.name}'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        context.read<UserRegisterBloc>().add(
                              UserRegisterEventPressDistrict(value!),
                            );
                      },
                    ),
                  );
          } else
            return Container();
        },
      ),
    );
  }

  Container buildSelectProvince(BuildContext context) {
    List<BaseAddress> provinceItems;
    BaseAddress currentProvince;

    return Container(
      child: BlocBuilder<UserRegisterBloc, UserRegisterState>(
        buildWhen: (previous, current) {
          if (current is UserRegisterStateGetProvinceSuccess)
            return true;
          else
            return false;
        },
        builder: (context, state) {
          if (state is UserRegisterStateGetProvinceSuccess) {
            provinceItems = state.provinceList;
            currentProvince = state.currentProvince;
            return provinceItems.length == 0
                ? Container()
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        borderRadius: BorderRadius.circular(16)),
                    child: DropdownButton<BaseAddress>(
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: currentProvince,
                      items: provinceItems
                          .map(
                            (e) => DropdownMenuItem<BaseAddress>(
                              value: e,
                              child: Text('${e.name}'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        context.read<UserRegisterBloc>().add(
                              UserRegisterEventPressProvince(value!),
                            );
                      },
                    ),
                  );
          } else
            return Container();
        },
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
