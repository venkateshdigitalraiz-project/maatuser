import '../entities/destination_entities.dart';
import '../repositories/destination_repository.dart';

class ManageSavedPlacesUseCase {
  final DestinationRepository repository;

  ManageSavedPlacesUseCase(this.repository);

  Future<List<AddressEntity>> getSavedPlaces() async {
    return await repository.getSavedPlaces();
  }

  Future<void> savePlace(String placeType, AddressEntity address) async {
    await repository.savePlace(placeType, address);
  }
}
