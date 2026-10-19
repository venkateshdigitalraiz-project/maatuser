import '../../domain/entities/ride_option_entity.dart';

class RideOptionModel extends RideOptionEntity {
  const RideOptionModel({
    required super.id,
    required super.title,
    required super.etaText,
    required super.fare,
    required super.vehicleType,
    super.isSelected = false,
    super.subtitle = '4 min away',
  });

  factory RideOptionModel.fromJson(Map<String, dynamic> json) {
    return RideOptionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      etaText: json['etaText'] as String,
      fare: (json['fare'] as num).toDouble(),
      vehicleType: json['vehicleType'] as String,
      isSelected: (json['isSelected'] as bool?) ?? false,
      subtitle: (json['subtitle'] as String?) ?? '4 min away',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'etaText': etaText,
      'fare': fare,
      'vehicleType': vehicleType,
      'isSelected': isSelected,
      'subtitle': subtitle,
    };
  }
}
