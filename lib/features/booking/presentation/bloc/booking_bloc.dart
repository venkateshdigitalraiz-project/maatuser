import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/ride_option_entity.dart';
import '../../domain/usecases/book_ride_usecase.dart';
import '../../domain/usecases/get_ride_options_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetRideOptionsUseCase getRideOptionsUseCase;
  final BookRideUseCase bookRideUseCase;

  BookingBloc({
    required this.getRideOptionsUseCase,
    required this.bookRideUseCase,
  }) : super(const BookingInitial()) {
    on<LoadRideOptionsEvent>(_onLoadRideOptions);
    on<SelectRideOptionEvent>(_onSelectRideOption);
    on<ChangePaymentMethodEvent>(_onChangePaymentMethod);
    on<ChangeRideScheduleEvent>(_onChangeRideSchedule);
    on<AddInstructionEvent>(_onAddInstruction);
    on<ConfirmBookRideEvent>(_onConfirmBookRide);
  }

  Future<void> _onLoadRideOptions(
    LoadRideOptionsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    try {
      final options = await getRideOptionsUseCase.execute(
        pickupAddress: event.pickupAddress,
        destinationAddress: event.destinationAddress,
      );

      RideOptionEntity selected = options.first;
      for (final opt in options) {
        if (opt.isSelected) {
          selected = opt;
          break;
        }
      }

      emit(BookingLoaded(
        pickupAddress: event.pickupAddress,
        destinationAddress: event.destinationAddress,
        rideOptions: options,
        selectedOption: selected,
      ));
    } catch (e) {
      emit(BookingError('Failed to load ride options: ${e.toString()}'));
    }
  }

  void _onSelectRideOption(
    SelectRideOptionEvent event,
    Emitter<BookingState> emit,
  ) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      final updatedList = currentState.rideOptions.map((opt) {
        return opt.copyWith(isSelected: opt.id == event.rideOption.id);
      }).toList();

      emit(currentState.copyWith(
        rideOptions: updatedList,
        selectedOption: event.rideOption,
      ));
    }
  }

  void _onChangePaymentMethod(
    ChangePaymentMethodEvent event,
    Emitter<BookingState> emit,
  ) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(
        paymentMethod: event.paymentMethod,
        actionMessage: 'Payment set to ${event.paymentMethod}',
      ));
    }
  }

  void _onChangeRideSchedule(
    ChangeRideScheduleEvent event,
    Emitter<BookingState> emit,
  ) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(
        schedule: event.schedule,
        actionMessage: 'Ride schedule set to ${event.schedule}',
      ));
    }
  }

  void _onAddInstruction(
    AddInstructionEvent event,
    Emitter<BookingState> emit,
  ) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(
        instructions: event.instruction,
        actionMessage: 'Instructions saved',
      ));
    }
  }

  Future<void> _onConfirmBookRide(
    ConfirmBookRideEvent event,
    Emitter<BookingState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BookingLoaded) return;

    emit(currentState.copyWith(isBookingInProgress: true));

    try {
      final confirmation = await bookRideUseCase.execute(
        rideOption: currentState.selectedOption,
        pickupAddress: currentState.pickupAddress,
        destinationAddress: currentState.destinationAddress,
        paymentMethod: currentState.paymentMethod,
        instructions: currentState.instructions,
      );

      emit(BookingConfirmedState(confirmation));
    } catch (e) {
      emit(currentState.copyWith(
        isBookingInProgress: false,
        actionMessage: 'Booking failed. Please try again.',
      ));
    }
  }
}
