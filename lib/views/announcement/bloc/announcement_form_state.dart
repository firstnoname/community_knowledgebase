part of 'announcement_form_bloc.dart';

@immutable
abstract class AnnouncementFormState {}

class AnnouncementFormStateInitial extends AnnouncementFormState {}

class AnnouncementFormStateInprogress extends AnnouncementFormState {}

class AnnouncementFormStateFailed extends AnnouncementFormState {
  final String reason;

  AnnouncementFormStateFailed(this.reason);
}

class AnnouncementFormStateSubmitSuccess extends AnnouncementFormState {}
