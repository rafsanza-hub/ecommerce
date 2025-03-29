import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class FetchProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? fullName;
  final String? email;
  const UpdateProfile({this.fullName, this.email});
  @override
  List<Object?> get props => [fullName, email];
}