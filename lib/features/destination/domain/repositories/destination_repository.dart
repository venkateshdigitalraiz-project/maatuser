import '../entities/destination_entities.dart';

abstract class DestinationRepository {
  Future<List<AddressEntity>> searchPlaces(String query);
  Future<List<AddressEntity>> getRecentPlaces();
  Future<List<AddressEntity>> getSavedPlaces();
  Future<void> savePlace(String placeType, AddressEntity address);
}
