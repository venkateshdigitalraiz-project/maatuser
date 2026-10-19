import '../entities/home_entities.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  const GetHomeDataUseCase(this.repository);

  Future<HomeDataEntity> call() async {
    return await repository.getHomeData();
  }
}
