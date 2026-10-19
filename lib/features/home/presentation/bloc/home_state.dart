import 'package:equatable/equatable.dart';
import '../../domain/entities/home_entities.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeDataEntity homeData;
  final RideServiceEntity? selectedService;

  const HomeLoaded({
    required this.homeData,
    this.selectedService,
  });

  HomeLoaded copyWith({
    HomeDataEntity? homeData,
    RideServiceEntity? selectedService,
  }) {
    return HomeLoaded(
      homeData: homeData ?? this.homeData,
      selectedService: selectedService ?? this.selectedService,
    );
  }

  @override
  List<Object?> get props => [homeData, selectedService];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
