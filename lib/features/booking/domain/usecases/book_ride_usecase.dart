import '../entities/ride_option_entity.dart';
import '../repositories/booking_repository.dart';

class BookRideUseCase {
  final BookingRepository repository;

  BookRideUseCase(this.repository);

  Future<BookingConfirmationEntity> execute({
    required RideOptionEntity rideOption,
    required String pickupAddress,
    required String destinationAddress,
    required String paymentMethod,
    String? instructions,
  }) async {
    return await repository.bookRide(
      rideOption: rideOption,
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      paymentMethod: paymentMethod,
      instructions: instructions,
    );
  }
}
