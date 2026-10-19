import 'package:equatable/equatable.dart';
import '../../domain/entities/ride_option_entity.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadRideOptionsEvent extends BookingEvent {
  final String pickupAddress;
  final String destinationAddress;

  const LoadRideOptionsEvent({
    required this.pickupAddress,
    required this.destinationAddress,
  });

  @override
  List<Object?> get props => [pickupAddress, destinationAddress];
}

class SelectRideOptionEvent extends BookingEvent {
  final RideOptionEntity rideOption;

  const SelectRideOptionEvent(this.rideOption);

  @override
  List<Object?> get props => [rideOption];
}

class ChangePaymentMethodEvent extends BookingEvent {
  final String paymentMethod;

  const ChangePaymentMethodEvent(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class ChangeRideScheduleEvent extends BookingEvent {
  final String schedule;

  const ChangeRideScheduleEvent(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class AddInstructionEvent extends BookingEvent {
  final String instruction;

  const AddInstructionEvent(this.instruction);

  @override
  List<Object?> get props => [instruction];
}

class ConfirmBookRideEvent extends BookingEvent {
  const ConfirmBookRideEvent();
}
