import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthSendingOtp extends AuthState {
  final String phoneNumber;

  const AuthSendingOtp({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthOtpSent extends AuthState {
  final String phoneNumber;
  final String message;
  final String currentOtp;
  final bool isResending;

  const AuthOtpSent({
    required this.phoneNumber,
    this.message = '4-digit OTP sent to your phone number',
    this.currentOtp = '',
    this.isResending = false,
  });

  AuthOtpSent copyWith({
    String? phoneNumber,
    String? message,
    String? currentOtp,
    bool? isResending,
  }) {
    return AuthOtpSent(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      message: message ?? this.message,
      currentOtp: currentOtp ?? this.currentOtp,
      isResending: isResending ?? this.isResending,
    );
  }

  @override
  List<Object?> get props => [phoneNumber, message, currentOtp, isResending];
}

class AuthVerifyingOtp extends AuthState {
  final String phoneNumber;
  final String otp;

  const AuthVerifyingOtp({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [phoneNumber, otp];
}

class AuthSuccess extends AuthState {
  final UserEntity user;
  final String message;

  const AuthSuccess({
    required this.user,
    this.message = 'Login successful! Ready to ride.',
  });

  @override
  List<Object?> get props => [user, message];
}

class AuthError extends AuthState {
  final String message;
  final bool isOtpStep;
  final String? phoneNumber;

  const AuthError({
    required this.message,
    required this.isOtpStep,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [message, isOtpStep, phoneNumber];
}
