import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<bool> sendOtp({required String phoneNumber});

  Future<UserEntity> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<bool> resendOtp({required String phoneNumber});
}
