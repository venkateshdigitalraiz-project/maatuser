import '../entities/destination_entities.dart';
import '../repositories/destination_repository.dart';

class SearchDestinationUseCase {
  final DestinationRepository repository;

  SearchDestinationUseCase(this.repository);

  Future<List<AddressEntity>> execute(String query) async {
    return await repository.searchPlaces(query);
  }
}
