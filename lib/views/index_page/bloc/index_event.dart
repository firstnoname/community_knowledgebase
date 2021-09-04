part of 'index_bloc.dart';

@immutable
abstract class IndexEvent {}

class IndexViewInitial extends IndexEvent {}

class LogoutPressed extends IndexEvent {}
