import '../../domain/entities/destination_entities.dart';
import '../../domain/repositories/destination_repository.dart';
import '../datasources/destination_remote_data_source.dart';
import '../models/destination_models.dart';

class DestinationRepositoryImpl implements DestinationRepository {
  final DestinationRemoteDataSource remoteDataSource;

  DestinationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AddressEntity>> searchPlaces(String query) async {
    return await remoteDataSource.searchPlaces(query);
  }

  @override
  Future<List<AddressEntity>> getRecentPlaces() async {
    return await remoteDataSource.getRecentPlaces();
  }

  @override
  Future<List<AddressEntity>> getSavedPlaces() async {
    return await remoteDataSource.getSavedPlaces();
  }

  @override
  Future<void> savePlace(String placeType, AddressEntity address) async {
    final model = AddressModel(
      id: address.id,
      title: address.title,
      subtitle: address.subtitle,
      latitude: address.latitude,
      longitude: address.longitude,
      distance: address.distance,
      tag: address.tag,
    );
    await remoteDataSource.savePlace(placeType, model);
  }
}
