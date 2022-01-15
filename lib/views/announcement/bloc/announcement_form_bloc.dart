import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/bloc/base_bloc.dart';
import 'package:community_knowledgebase/models/member.dart';
import 'package:community_knowledgebase/services/announcement_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:meta/meta.dart';

import '../../../models/announcement.dart';

part 'announcement_form_event.dart';
part 'announcement_form_state.dart';

class AnnouncementFormBloc
    extends BaseBloc<AnnouncementFormEvent, AnnouncementFormState> {
  AnnouncementFormBloc(BuildContext context)
      : super(context, AnnouncementFormStateInitial()) {
    this.add(AnnouncementFormEventInitial());
  }

  late Announcement _announcement = Announcement(
      title: '', content: '', member: Member(), createDate: Timestamp.now());
  get announchment => _announcement;

  @override
  Stream<AnnouncementFormState> mapEventToState(
    AnnouncementFormEvent event,
  ) async* {
    try {
      switch (event.runtimeType) {
        case AnnouncementFormEventInitial:
          break;
        case AnnouncementFormEventSubmitted:
          _announcement =
              (event as AnnouncementFormEventSubmitted).announcement;
          _announcement.member = appManagerBloc.member;
          var result = await AnnouncementServices()
              .addAnnouncement(_announcement, imagesByte: event.images);

          if (result == true) {
            yield AnnouncementFormStateSubmitSuccess();
            Navigator.pop(context);
          } else
            yield AnnouncementFormStateFailed(
                'Add annoucement failed, something went wrong in announcement_api.');

          break;

        default:
      }
    } on Exception catch (e) {
      print('Announcement bloc failed -> ${e.toString()}');
    }
  }
}
