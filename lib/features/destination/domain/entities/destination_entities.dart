import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final double? latitude;
  final double? longitude;
  final String distance;
  final String tag; // 'home', 'work', 'recent', 'other', 'station', 'mall'

  const AddressEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    this.latitude,
    this.longitude,
    this.distance = '',
    this.tag = 'recent',
  });

  @override
  List<Object?> get props => [id, title, subtitle, latitude, longitude, distance, tag];
}

class TripStopEntity extends Equatable {
  final String id;
  final String address;
  final double? latitude;
  final double? longitude;

  const TripStopEntity({
    required this.id,
    required this.address,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [id, address, latitude, longitude];
}
