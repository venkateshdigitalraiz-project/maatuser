import 'dart:async';
import '../models/home_models.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<HomeDataModel> getHomeData() async {
    // Simulate real network fetch
    await Future.delayed(const Duration(milliseconds: 400));

    final services = [
      const RideServiceModel(
        id: 'bike',
        title: 'Bike',
        subtitle: 'Fastest doorstep ride',
        emoji: '🛵',
        estimatedFare: 35.0,
        eta: '2 min',
        tag: 'Popular',
        isPopular: true,
      ),
      const RideServiceModel(
        id: 'auto',
        title: 'Auto',
        subtitle: 'Affordable daily commute',
        emoji: '🛺',
        estimatedFare: 55.0,
        eta: '3 min',
        tag: 'Doorstep',
        isPopular: true,
      ),
      const RideServiceModel(
        id: 'cab',
        title: 'Cab',
        subtitle: 'Comfortable AC Sedan',
        emoji: '🚕',
        estimatedFare: 110.0,
        eta: '4 min',
        tag: 'Comfort',
        isPopular: true,
      ),
      const RideServiceModel(
        id: 'parcel',
        title: 'Parcel',
        subtitle: 'Fast box & item delivery',
        emoji: '📦',
        estimatedFare: 45.0,
        eta: '5 min',
        tag: 'Express',
        isPopular: false,
      ),
      const RideServiceModel(
        id: 'rentals',
        title: 'Rentals',
        subtitle: 'Book car with driver by hour',
        emoji: '⏱️',
        estimatedFare: 299.0,
        eta: 'Hourly',
        tag: 'Flexible',
        isPopular: false,
      ),
      const RideServiceModel(
        id: 'outstation',
        title: 'Outstation',
        subtitle: 'One-way & round trip intercity',
        emoji: '🛡️',
        estimatedFare: 899.0,
        eta: 'Intercity',
        tag: 'Verified',
        isPopular: false,
      ),
    ];

    final recentPlaces = [
      const RecentPlaceModel(
        id: 'place_jntu',
        title: 'JNTU College Metro Station',
        subtitle: 'KPHB 6th Phase, Hyderabad',
        iconType: 'metro',
        distance: '1.2 km',
      ),
      const RecentPlaceModel(
        id: 'place_kukatpally',
        title: 'Kukatpally Housing Board (KPHB)',
        subtitle: 'Rythubazar Road, Hyderabad',
        iconType: 'pin',
        distance: '2.4 km',
      ),
      const RecentPlaceModel(
        id: 'place_hitech',
        title: 'Hitec City Cyber Towers',
        subtitle: 'Madhapur, Hyderabad',
        iconType: 'work',
        distance: '6.8 km',
      ),
    ];

    final promoBanners = [
      const PromoBannerModel(
        id: 'promo_1',
        title: 'Special Ride Discount',
        description: 'Get 25% off on your next 3 city rides',
        promoCode: 'RIDE25',
        discountBadge: '25% OFF',
        iconEmoji: '🎉',
      ),
    ];

    return HomeDataModel(
      currentCity: 'Hyderabad',
      currentAddress: 'Manjeera Majestic Commercial, 30',
      services: services,
      recentPlaces: recentPlaces,
      promoBanners: promoBanners,
    );
  }
}
