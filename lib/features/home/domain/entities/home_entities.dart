import 'package:equatable/equatable.dart';

class RideServiceEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final double estimatedFare;
  final String eta;
  final String tag;
  final bool isPopular;

  const RideServiceEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.estimatedFare,
    required this.eta,
    this.tag = '',
    this.isPopular = false,
  });

  @override
  List<Object?> get props => [id, title, subtitle, emoji, estimatedFare, eta, tag, isPopular];
}

class RecentPlaceEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String iconType; // home, work, airport, metro, pin
  final String distance;

  const RecentPlaceEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconType,
    required this.distance,
  });

  @override
  List<Object?> get props => [id, title, subtitle, iconType, distance];
}

class PromoBannerEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String promoCode;
  final String discountBadge;
  final String iconEmoji;

  const PromoBannerEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.promoCode,
    required this.discountBadge,
    required this.iconEmoji,
  });

  @override
  List<Object?> get props => [id, title, description, promoCode, discountBadge, iconEmoji];
}

class HomeDataEntity extends Equatable {
  final String currentCity;
  final String currentAddress;
  final List<RideServiceEntity> services;
  final List<RecentPlaceEntity> recentPlaces;
  final List<PromoBannerEntity> promoBanners;

  const HomeDataEntity({
    required this.currentCity,
    required this.currentAddress,
    required this.services,
    required this.recentPlaces,
    required this.promoBanners,
  });

  @override
  List<Object?> get props => [currentCity, currentAddress, services, recentPlaces, promoBanners];
}
