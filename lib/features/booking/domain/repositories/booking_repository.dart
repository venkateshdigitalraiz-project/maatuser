import '../entities/ride_option_entity.dart';

abstract class BookingRepository {
  Future<List<RideOptionEntity>> getRideOptions({
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
