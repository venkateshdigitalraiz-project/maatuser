import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/destination_entities.dart';
import '../../domain/usecases/get_recent_destinations_usecase.dart';
import '../../domain/usecases/manage_saved_places_usecase.dart';
import '../../domain/usecases/search_destination_usecase.dart';
import 'destination_event.dart';
import 'destination_state.dart';

class DestinationBloc extends Bloc<DestinationEvent, DestinationState> {
  final SearchDestinationUseCase searchDestinationUseCase;
  final GetRecentDestinationsUseCase getRecentDestinationsUseCase;
  final ManageSavedPlacesUseCase manageSavedPlacesUseCase;

  DestinationBloc({
    required this.searchDestinationUseCase,
    required this.getRecentDestinationsUseCase,
    required this.manageSavedPlacesUseCase,
  }) : super(const DestinationInitial()) {
    on<InitDestinationSearchEvent>(_onInit);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SelectPickupAddressEvent>(_onSelectPickup);
    on<ClearPickupEvent>(_onClearPickup);
    on<SelectDestinationAddressEvent>(_onSelectDestination);
    on<ClearDestinationEvent>(_onClearDestination);
    on<AddStopEvent>(_onAddStop);
    on<RemoveStopEvent>(_onRemoveStop);
    on<SelectFromMapEvent>(_onSelectFromMap);
    on<QuickPlaceTappedEvent>(_onQuickPlaceTapped);
  }

  Future<void> _onInit(
    InitDestinationSearchEvent event,
    Emitter<DestinationState> emit,
  ) async {
    emit(const DestinationLoading());
    try {
      final recent = await getRecentDestinationsUseCase.execute();
      final saved = await manageSavedPlacesUseCase.getSavedPlaces();

      emit(DestinationLoaded(
        pickupAddress: event.initialPickup,
        recentPlaces: recent,
        searchResults: recent,
        savedPlaces: saved,
      ));
    } catch (e) {
      emit(DestinationError('Failed to load places: ${e.toString()}'));
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<DestinationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DestinationLoaded) return;

    final query = event.query;
    if (query.trim().isEmpty) {
      emit(currentState.copyWith(
        searchQuery: '',
        searchResults: currentState.recentPlaces,
        isSearching: false,
      ));
      return;
    }

    emit(currentState.copyWith(searchQuery: query, isSearching: true));

    try {
      final results = await searchDestinationUseCase.execute(query);
      emit(currentState.copyWith(
        searchQuery: query,
        searchResults: results,
        isSearching: false,
      ));
    } catch (_) {
      emit(currentState.copyWith(isSearching: false));
    }
  }

  void _onSelectPickup(
    SelectPickupAddressEvent event,
    Emitter<DestinationState> emit,
  ) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      emit(currentState.copyWith(pickupAddress: event.address));
    }
  }

  void _onClearPickup(
    ClearPickupEvent event,
    Emitter<DestinationState> emit,
  ) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      emit(currentState.copyWith(pickupAddress: ''));
    }
  }

  void _onSelectDestination(
    SelectDestinationAddressEvent event,
    Emitter<DestinationState> emit,
  ) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      emit(currentState.copyWith(
        destinationAddress: event.address.title,
        selectedDestination: event.address,
      ));
    }
  }

  void _onClearDestination(
    ClearDestinationEvent event,
    Emitter<DestinationState> emit,
  ) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      emit(currentState.copyWith(
        destinationAddress: '',
        selectedDestination: null,
        searchQuery: '',
        searchResults: currentState.recentPlaces,
      ));
    }
  }

  void _onAddStop(
    AddStopEvent event,
    Emitter<DestinationState> emit,
  ) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      if (currentState.stops.length >= 3) {
        emit(currentState.copyWith(actionMessage: 'Maximum 3 stops allowed'));
        return;
      }
      final newStops = List<String>.from(currentState.stops)..add('');
      emit(currentState.copyWith(
        stops: newStops,
        actionMessage: 'Stop added. Enter stop address.',
      ));
    }
  }

  void _onRemoveStop(
    RemoveStopEvent event,
    Emitter<DestinationState> emit,
  ) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      if (event.index >= 0 && event.index < currentState.stops.length) {
        final newStops = List<String>.from(currentState.stops)..removeAt(event.index);
        emit(currentState.copyWith(stops: newStops));
      }
    }
  }

  void _onSelectFromMap(
    SelectFromMapEvent event,
    Emitter<DestinationState> emit,
  ) {
    final currentState = state;
    if (currentState is DestinationLoaded) {
      emit(currentState.copyWith(
        actionMessage: '📍 Moving to map to pinpoint destination...',
      ));
    }
  }

  Future<void> _onQuickPlaceTapped(
    QuickPlaceTappedEvent event,
    Emitter<DestinationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DestinationLoaded) return;

    final placeType = event.placeType.toLowerCase();
    final matched = currentState.savedPlaces.firstWhere(
      (p) => p.tag.toLowerCase() == placeType,
      orElse: () => AddressEntity(
        id: 'new_$placeType',
        title: placeType == 'home'
            ? 'Home'
            : placeType == 'work'
                ? 'Work'
                : 'Others',
        subtitle: 'Tap to set ${placeType[0].toUpperCase()}${placeType.substring(1)} address',
        tag: placeType,
      ),
    );

    emit(currentState.copyWith(
      destinationAddress: matched.title,
      selectedDestination: matched,
      actionMessage: 'Selected ${matched.title}',
    ));
  }
}
