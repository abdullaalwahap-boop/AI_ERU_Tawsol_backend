part of 'contact_cubit.dart';

sealed class ContactState {}

final class ContactInitial extends ContactState {}

final class ContactLoading extends ContactState {}

final class ContactSuccess extends ContactState {}

final class ContactFailure extends ContactState {
  ContactFailure(this.message);
  final String message;
}
