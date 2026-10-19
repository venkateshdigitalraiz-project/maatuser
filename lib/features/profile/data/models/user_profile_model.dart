import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.phoneNumber,
    required super.email,
    required super.rating,
    required super.totalRides,
    required super.co2SavedKg,
    required super.walletBalance,
    required super.membershipTier,
    required super.memberSince,
    required super.emergencyContact,
    required super.carpoolPreferences,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalRides: json['total_rides'] as int,
      co2SavedKg: (json['co2_saved_kg'] as num).toDouble(),
      walletBalance: (json['wallet_balance'] as num).toDouble(),
      membershipTier: json['membership_tier'] as String,
      memberSince: json['member_since'] as String,
      emergencyContact: json['emergency_contact'] as String,
      carpoolPreferences: Map<String, String>.from(json['carpool_preferences'] as Map),
    );
  }
}
