import 'package:equatable/equatable.dart';
import '../../domain/entities/home_entities.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {
  const LoadHomeDataEvent();
}

class SelectServiceEvent extends HomeEvent {
  final RideServiceEntity service;

  const SelectServiceEvent(this.service);

  @override
  List<Object?> get props => [service];
}

class SearchDestinationEvent extends HomeEvent {
  final String query;

  const SearchDestinationEvent(this.query);

  @override
  List<Object?> get props => [query];
}
