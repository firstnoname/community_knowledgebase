part of 'verification_bloc.dart';

@immutable
abstract class VerificationState {}

class VerificationInitialState extends VerificationState {}

class VerficationInprogress extends VerificationState {}

class VerificationPrepareSuccess extends VerificationState {}
