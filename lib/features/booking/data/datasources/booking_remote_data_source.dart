import 'dart:async';
import '../../domain/entities/ride_option_entity.dart';
import '../models/ride_option_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<RideOptionModel>> getRideOptions({
    required String pickupAddress,
    required String destinationAddress,
  });

  Future<BookingConfirmationEntity> bookRide({
    required RideOptionEntity rideOption,
    required String pickupAddress,
    required String destinationAddress,
    required String paymentMethod,
    String? instructions,
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  @override
  Future<List<RideOptionModel>> getRideOptions({
    required String pickupAddress,
    required String destinationAddress,
  }) async {
    return const [
      RideOptionModel(
        id: 'opt_auto',
        title: 'Auto',
        etaText: '4 min away',
        fare: 143.0,
        vehicleType: 'auto',
        isSelected: true,
        subtitle: '4 min away',
      ),
      RideOptionModel(
        id: 'opt_bike',
        title: 'Bike',
        etaText: '4 min away',
        fare: 129.0,
        vehicleType: 'bike',
        isSelected: false,
        subtitle: '4 min away',
      ),
      RideOptionModel(
        id: 'opt_economy_car',
        title: 'Economy Car',
        etaText: '4 min away',
        fare: 297.0,
        vehicleType: 'car',
        isSelected: false,
        subtitle: '4 min away',
      ),
    ];
  }

  @override
  Future<BookingConfirmationEntity> bookRide({
    required RideOptionEntity rideOption,
    required String pickupAddress,
    required String destinationAddress,
    required String paymentMethod,
    String? instructions,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final bookingId = 'BK${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
    return BookingConfirmationEntity(
      bookingId: bookingId,
      rideOptionId: rideOption.id,
      rideOptionTitle: rideOption.title,
      fare: rideOption.fare,
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      paymentMethod: paymentMethod,
      status: 'driver_assigned',
      otp: '4821',
    );
  }
}
