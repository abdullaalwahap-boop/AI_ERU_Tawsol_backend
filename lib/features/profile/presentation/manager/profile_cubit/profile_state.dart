part of 'profile_cubit.dart';

sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final ProfileUser user;
  ProfileLoaded(this.user);
}

final class ProfileUpdating extends ProfileState {
  final ProfileUser user;
  ProfileUpdating(this.user);
}

final class ProfileUpdateSuccess extends ProfileState {
  final ProfileUser user;
  ProfileUpdateSuccess(this.user);
}

final class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
