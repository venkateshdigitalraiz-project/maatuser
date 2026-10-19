import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? token;
  final String? email;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.token,
    this.email,
  });

  @override
  List<Object?> get props => [id, phoneNumber, name, token, email];
}
