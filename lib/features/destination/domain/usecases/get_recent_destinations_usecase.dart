import '../entities/destination_entities.dart';
import '../repositories/destination_repository.dart';

class GetRecentDestinationsUseCase {
  final DestinationRepository repository;

  GetRecentDestinationsUseCase(this.repository);

  Future<List<AddressEntity>> execute() async {
    return await repository.getRecentPlaces();
  }
}
