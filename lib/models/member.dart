import 'package:community_knowledgebase/models/models.dart';

class Member {
  String? memberId;
  String? memberDisplayname;
  String? memberFirsname;
  String? memberLastname;
  String? memberCity;
  String? memberProvince;
  String? memberPhone;
  String? memberStatus;
  String? memberEmail;
  String? memberUsername;
  String? memberPassword;
  Address? memberAddress;
  String? memberRole;

  Member({
    this.memberId,
    this.memberDisplayname,
    this.memberFirsname,
    this.memberLastname,
    this.memberCity,
    this.memberProvince,
    this.memberPhone,
    this.memberStatus,
    this.memberEmail,
    this.memberUsername,
    this.memberPassword,
    this.memberAddress,
  });

  factory Member.fromJson(dynamic json) => Member(
        memberId: json['id'],
        memberDisplayname: json['member_display_name'],
        memberFirsname: json['member_firstname'],
        memberLastname: json['member_lastname'],
        memberCity: json['member_city'],
        memberProvince: json['member_province'],
        memberPhone: json['member_phone'],
        memberStatus: json['member_status'],
        memberEmail: json['member_email'],
        memberUsername: json['member_username'],
        memberPassword: json['member_password'],
        memberAddress: json['member_address'] != null
            ? Address.fromJson(json['member_address'])
            : null,
      );

  factory Member.fromMinimalJson(dynamic json) => Member(
      memberId: json['member_id'],
      memberDisplayname: json['member_display_name']);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    // map['member_id'] = memberId;
    map['member_display_name'] = memberDisplayname;
    map['member_firstname'] = memberFirsname;
    map['member_lastname'] = memberLastname;
    map['member_city'] = memberCity;
    map['member_province'] = memberProvince;
    map['member_phone'] = memberPhone;
    map['member_status'] = memberStatus;
    map['member_email'] = memberEmail;
    map['member_username'] = memberUsername;
    map['member_password'] = memberPassword;
    map['member_address'] =
        memberAddress != null ? memberAddress!.toJson() : null;

    return map;
  }

  Map<String, dynamic> toMinimalJson() {
    var map = <String, dynamic>{};
    map['user_id'] = memberId;
    map['member_display_name'] = memberDisplayname;
    return map;
  }
}
