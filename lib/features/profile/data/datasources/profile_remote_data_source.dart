import 'dart:async';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<UserProfileModel> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const UserProfileModel(
      id: 'rider_77492',
      name: 'Rahul Sharma',
      phoneNumber: '9876543210',
      email: 'rahul.sharma@mobility.com',
      rating: 4.93,
      totalRides: 48,
      co2SavedKg: 26.4,
      walletBalance: 385.50,
      membershipTier: 'Gold Rider • Verified Member',
      memberSince: 'March 2023',
      emergencyContact: '+91 98450 12345 (Dad)',
      carpoolPreferences: {
        'Chat': 'Friendly & open to talk',
        'Music': 'Acoustic, Bollywood & Indie',
        'Smoking': 'Strictly No smoking',
        'Pets': 'Pet friendly',
      },
    );
  }
}
