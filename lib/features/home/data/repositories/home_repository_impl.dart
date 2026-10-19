import '../../../../core/errors/failures.dart';
import '../../domain/entities/home_entities.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeDataEntity> getHomeData() async {
    try {
      return await remoteDataSource.getHomeData();
    } catch (e) {
      throw ServerFailure('Unable to fetch mobility options: $e');
    }
  }
}
