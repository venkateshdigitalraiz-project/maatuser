import 'package:equatable/equatable.dart';

class RideOptionEntity extends Equatable {
  final String id;
  final String title;
  final String etaText;
  final double fare;
  final String vehicleType; // 'auto', 'bike', 'car'
  final bool isSelected;
  final String subtitle;

  const RideOptionEntity({
    required this.id,
    required this.title,
    required this.etaText,
    required this.fare,
    required this.vehicleType,
    this.isSelected = false,
    this.subtitle = '4 min away',
  });

  RideOptionEntity copyWith({
    String? id,
    String? title,
    String? etaText,
    double? fare,
    String? vehicleType,
    bool? isSelected,
    String? subtitle,
  }) {
    return RideOptionEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      etaText: etaText ?? this.etaText,
      fare: fare ?? this.fare,
      vehicleType: vehicleType ?? this.vehicleType,
      isSelected: isSelected ?? this.isSelected,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  @override
  List<Object?> get props => [id, title, etaText, fare, vehicleType, isSelected, subtitle];
}

class BookingConfirmationEntity extends Equatable {
  final String bookingId;
  final String rideOptionId;
  final String rideOptionTitle;
  final double fare;
  final String pickupAddress;
  final String destinationAddress;
  final String paymentMethod;
  final String status;
  final String otp;

  const BookingConfirmationEntity({
    required this.bookingId,
    required this.rideOptionId,
    required this.rideOptionTitle,
    required this.fare,
    required this.pickupAddress,
    required this.destinationAddress,
    this.paymentMethod = 'Cash',
    this.status = 'searching_driver',
    this.otp = '4821',
  });

  @override
  List<Object?> get props => [
        bookingId,
        rideOptionId,
        rideOptionTitle,
        fare,
        pickupAddress,
        destinationAddress,
        paymentMethod,
        status,
        otp,
      ];
}
