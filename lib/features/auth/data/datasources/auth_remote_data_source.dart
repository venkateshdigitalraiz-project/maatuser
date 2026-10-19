import 'dart:async';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> sendOtp({required String phoneNumber});
  Future<UserModel> verifyOtp({required String phoneNumber, required String otp});
  Future<bool> resendOtp({required String phoneNumber});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  static const String demoOtp = '1234';

  @override
  Future<bool> sendOtp({required String phoneNumber}) async {
    // Simulate real network latency
    await Future.delayed(const Duration(milliseconds: 1100));

    if (phoneNumber.trim().isEmpty) {
      throw const ValidationException('Please provide a valid mobile number');
    }

    return true;
  }

  @override
  Future<UserModel> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    // Reject incorrect OTP (e.g. 0000 or anything not 4 digits)
    if (otp == '0000') {
      throw const InvalidOtpException('Invalid code. For demo, please enter 1234.');
    }

    if (otp.length != 4) {
      throw const InvalidOtpException('Verification code must be 4 digits.');
    }

    return UserModel(
      id: 'rider_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
      name: 'Rider Partner',
      token: 'jwt_token_${DateTime.now().millisecondsSinceEpoch}',
      email: 'rider@mobility.com',
    );
  }

  @override
  Future<bool> resendOtp({required String phoneNumber}) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return true;
  }
}
