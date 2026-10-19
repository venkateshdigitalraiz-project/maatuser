import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final double rating;
  final int totalRides;
  final double co2SavedKg;
  final double walletBalance;
  final String membershipTier;
  final String memberSince;
  final String emergencyContact;
  final Map<String, String> carpoolPreferences;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.rating,
    required this.totalRides,
    required this.co2SavedKg,
    required this.walletBalance,
    required this.membershipTier,
    required this.memberSince,
    required this.emergencyContact,
    required this.carpoolPreferences,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        email,
        rating,
        totalRides,
        co2SavedKg,
        walletBalance,
        membershipTier,
        memberSince,
        emergencyContact,
        carpoolPreferences,
      ];
}
