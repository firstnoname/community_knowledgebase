part of 'announcement_form_bloc.dart';

@immutable
abstract class AnnouncementFormEvent {}

class AnnouncementFormEventInitial extends AnnouncementFormEvent {}

class AnnouncementFormEventInprogress extends AnnouncementFormEvent {}

class AnnouncementFormEventSubmitted extends AnnouncementFormEvent {
  final Announcement announcement;
  final MediaInfo? image;

  AnnouncementFormEventSubmitted(this.announcement, {this.image});
}
