import 'package:equatable/equatable.dart';
import '../../domain/entities/destination_entities.dart';

abstract class DestinationState extends Equatable {
  const DestinationState();

  @override
  List<Object?> get props => [];
}

class DestinationInitial extends DestinationState {
  const DestinationInitial();
}

class DestinationLoading extends DestinationState {
  const DestinationLoading();
}

class DestinationLoaded extends DestinationState {
  final String pickupAddress;
  final String destinationAddress;
  final AddressEntity? selectedDestination;
  final List<String> stops;
  final String searchQuery;
  final List<AddressEntity> searchResults;
  final List<AddressEntity> recentPlaces;
  final List<AddressEntity> savedPlaces;
  final bool isSearching;
  final String? actionMessage;

  const DestinationLoaded({
    required this.pickupAddress,
    this.destinationAddress = '',
    this.selectedDestination,
    this.stops = const [],
    this.searchQuery = '',
    this.searchResults = const [],
    this.recentPlaces = const [],
    this.savedPlaces = const [],
    this.isSearching = false,
    this.actionMessage,
  });

  DestinationLoaded copyWith({
    String? pickupAddress,
    String? destinationAddress,
    AddressEntity? selectedDestination,
    List<String>? stops,
    String? searchQuery,
    List<AddressEntity>? searchResults,
    List<AddressEntity>? recentPlaces,
    List<AddressEntity>? savedPlaces,
    bool? isSearching,
    String? actionMessage,
    bool clearActionMessage = false,
  }) {
    return DestinationLoaded(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      selectedDestination: selectedDestination ?? this.selectedDestination,
      stops: stops ?? this.stops,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
      recentPlaces: recentPlaces ?? this.recentPlaces,
      savedPlaces: savedPlaces ?? this.savedPlaces,
      isSearching: isSearching ?? this.isSearching,
      actionMessage: clearActionMessage ? null : (actionMessage ?? this.actionMessage),
    );
  }

  @override
  List<Object?> get props => [
        pickupAddress,
        destinationAddress,
        selectedDestination,
        stops,
        searchQuery,
        searchResults,
        recentPlaces,
        savedPlaces,
        isSearching,
        actionMessage,
      ];
}

class DestinationError extends DestinationState {
  final String message;

  const DestinationError(this.message);

  @override
  List<Object?> get props => [message];
}
