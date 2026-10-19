import 'package:equatable/equatable.dart';
import '../../domain/entities/ride_option_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingLoading extends BookingState {
  const BookingLoading();
}

class BookingLoaded extends BookingState {
  final String pickupAddress;
  final String destinationAddress;
  final List<RideOptionEntity> rideOptions;
  final RideOptionEntity selectedOption;
  final String paymentMethod;
  final String schedule;
  final String? instructions;
  final bool isBookingInProgress;
  final String? actionMessage;

  const BookingLoaded({
    required this.pickupAddress,
    required this.destinationAddress,
    required this.rideOptions,
    required this.selectedOption,
    this.paymentMethod = 'Cash',
    this.schedule = 'Now',
    this.instructions,
    this.isBookingInProgress = false,
    this.actionMessage,
  });

  BookingLoaded copyWith({
    String? pickupAddress,
    String? destinationAddress,
    List<RideOptionEntity>? rideOptions,
    RideOptionEntity? selectedOption,
    String? paymentMethod,
    String? schedule,
    String? instructions,
    bool? isBookingInProgress,
    String? actionMessage,
    bool clearActionMessage = false,
  }) {
    return BookingLoaded(
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      rideOptions: rideOptions ?? this.rideOptions,
      selectedOption: selectedOption ?? this.selectedOption,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      schedule: schedule ?? this.schedule,
      instructions: instructions ?? this.instructions,
      isBookingInProgress: isBookingInProgress ?? this.isBookingInProgress,
      actionMessage: clearActionMessage ? null : (actionMessage ?? this.actionMessage),
    );
  }

  @override
  List<Object?> get props => [
        pickupAddress,
        destinationAddress,
        rideOptions,
        selectedOption,
        paymentMethod,
        schedule,
        instructions,
        isBookingInProgress,
        actionMessage,
      ];
}

class BookingConfirmedState extends BookingState {
  final BookingConfirmationEntity confirmation;

  const BookingConfirmedState(this.confirmation);

  @override
  List<Object?> get props => [confirmation];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
