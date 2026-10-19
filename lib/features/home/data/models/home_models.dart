import '../../domain/entities/home_entities.dart';

class RideServiceModel extends RideServiceEntity {
  const RideServiceModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.emoji,
    required super.estimatedFare,
    required super.eta,
    super.tag,
    super.isPopular,
  });

  factory RideServiceModel.fromJson(Map<String, dynamic> json) {
    return RideServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      emoji: json['emoji'] as String,
      estimatedFare: (json['estimated_fare'] as num).toDouble(),
      eta: json['eta'] as String,
      tag: json['tag'] as String? ?? '',
      isPopular: json['is_popular'] as bool? ?? false,
    );
  }
}

class RecentPlaceModel extends RecentPlaceEntity {
  const RecentPlaceModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.iconType,
    required super.distance,
  });

  factory RecentPlaceModel.fromJson(Map<String, dynamic> json) {
    return RecentPlaceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      iconType: json['icon_type'] as String,
      distance: json['distance'] as String,
    );
  }
}

class PromoBannerModel extends PromoBannerEntity {
  const PromoBannerModel({
    required super.id,
    required super.title,
    required super.description,
    required super.promoCode,
    required super.discountBadge,
    required super.iconEmoji,
  });

  factory PromoBannerModel.fromJson(Map<String, dynamic> json) {
    return PromoBannerModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      promoCode: json['promo_code'] as String,
      discountBadge: json['discount_badge'] as String,
      iconEmoji: json['icon_emoji'] as String,
    );
  }
}

class HomeDataModel extends HomeDataEntity {
  const HomeDataModel({
    required super.currentCity,
    required super.currentAddress,
    required super.services,
    required super.recentPlaces,
    required super.promoBanners,
  });
}
