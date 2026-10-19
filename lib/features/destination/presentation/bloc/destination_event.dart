import 'package:equatable/equatable.dart';
import '../../domain/entities/destination_entities.dart';

abstract class DestinationEvent extends Equatable {
  const DestinationEvent();

  @override
  List<Object?> get props => [];
}

class InitDestinationSearchEvent extends DestinationEvent {
  final String initialPickup;

  const InitDestinationSearchEvent({this.initialPickup = 'Manjeera Majestic Commercial, 30'});

  @override
  List<Object?> get props => [initialPickup];
}

class SearchQueryChangedEvent extends DestinationEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SelectPickupAddressEvent extends DestinationEvent {
  final String address;

  const SelectPickupAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class ClearPickupEvent extends DestinationEvent {
  const ClearPickupEvent();
}

class SelectDestinationAddressEvent extends DestinationEvent {
  final AddressEntity address;

  const SelectDestinationAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class ClearDestinationEvent extends DestinationEvent {
  const ClearDestinationEvent();
}

class AddStopEvent extends DestinationEvent {
  const AddStopEvent();
}

class RemoveStopEvent extends DestinationEvent {
  final int index;

  const RemoveStopEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class SelectFromMapEvent extends DestinationEvent {
  const SelectFromMapEvent();
}

class QuickPlaceTappedEvent extends DestinationEvent {
  final String placeType; // 'home', 'work', 'others'

  const QuickPlaceTappedEvent(this.placeType);

  @override
  List<Object?> get props => [placeType];
}
