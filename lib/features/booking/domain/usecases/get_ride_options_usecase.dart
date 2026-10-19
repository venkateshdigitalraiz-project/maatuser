import '../entities/ride_option_entity.dart';
import '../repositories/booking_repository.dart';

class GetRideOptionsUseCase {
  final BookingRepository repository;

  GetRideOptionsUseCase(this.repository);

  Future<List<RideOptionEntity>> execute({
    required String pickupAddress,
    required String destinationAddress,
  }) async {
    return await repository.getRideOptions(
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
    );
  }
}
