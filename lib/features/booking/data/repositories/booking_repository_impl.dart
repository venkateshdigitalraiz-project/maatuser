import '../../domain/entities/ride_option_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RideOptionEntity>> getRideOptions({
    required String pickupAddress,
    required String destinationAddress,
  }) async {
    return await remoteDataSource.getRideOptions(
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
    );
  }

  @override
  Future<BookingConfirmationEntity> bookRide({
    required RideOptionEntity rideOption,
    required String pickupAddress,
    required String destinationAddress,
    required String paymentMethod,
    String? instructions,
  }) async {
    return await remoteDataSource.bookRide(
      rideOption: rideOption,
      pickupAddress: pickupAddress,
      destinationAddress: destinationAddress,
      paymentMethod: paymentMethod,
      instructions: instructions,
    );
  }
}
