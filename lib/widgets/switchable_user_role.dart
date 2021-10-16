import 'package:community_knowledgebase/models/member.dart';
import 'package:community_knowledgebase/services/services.dart';
import 'package:flutter/material.dart';

class SwitchableUserRole extends StatefulWidget {
  final Member user;

  const SwitchableUserRole({Key? key, required this.user}) : super(key: key);

  @override
  State<SwitchableUserRole> createState() => _SwitchableUserRoleState();
}

class _SwitchableUserRoleState extends State<SwitchableUserRole> {
  bool _isAdmin = true;

  @override
  Widget build(BuildContext context) {
    if (widget.user.memberStatus == 'user') _isAdmin = false;
    return Card(
      child: ListTile(
        // leading: FlutterLogo(size: 56.0),
        title: Text('${widget.user.memberDisplayname}'),
        subtitle: Text('${widget.user.memberStatus}'),
        trailing: Switch(
          value: _isAdmin,
          onChanged: (value) async {
            await UserServices().changeUserStatus(
                userId: widget.user.memberId!, isAdmin: value);
            setState(() {
              _isAdmin = value;
            });
          },
          activeTrackColor: Colors.yellow,
          activeColor: Colors.orangeAccent,
        ),
      ),
    );
  }
}
