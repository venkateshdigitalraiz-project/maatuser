import 'dart:async';
import '../models/destination_models.dart';

abstract class DestinationRemoteDataSource {
  Future<List<AddressModel>> searchPlaces(String query);
  Future<List<AddressModel>> getRecentPlaces();
  Future<List<AddressModel>> getSavedPlaces();
  Future<void> savePlace(String placeType, AddressModel address);
}

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  final List<AddressModel> _allAvailablePlaces = const [
    AddressModel(
      id: 'addr_jntu',
      title: 'JNTU College Metro Station',
      subtitle: 'KPHB 6th Phase, Kukatpally, Hyderabad',
      latitude: 17.4981,
      longitude: 78.3918,
      distance: '1.2 km',
      tag: 'station',
    ),
    AddressModel(
      id: 'addr_kukatpally',
      title: 'Kukatpally Housing Board (KPHB)',
      subtitle: 'Rythubazar Road, Kukatpally, Hyderabad',
      latitude: 17.4875,
      longitude: 78.3953,
      distance: '2.1 km',
      tag: 'recent',
    ),
    AddressModel(
      id: 'addr_hitec',
      title: 'Hitec City Cyber Towers',
      subtitle: 'HITEC City Main Road, Madhapur, Hyderabad',
      latitude: 17.4504,
      longitude: 78.3808,
      distance: '5.8 km',
      tag: 'work',
    ),
    AddressModel(
      id: 'addr_inorbit',
      title: 'Inorbit Mall Cyberabad',
      subtitle: 'Mindspace IT Park, Madhapur, Hyderabad',
      latitude: 17.4359,
      longitude: 78.3878,
      distance: '7.2 km',
      tag: 'mall',
    ),
    AddressModel(
      id: 'addr_gachibowli',
      title: 'Gachibowli Financial District',
      subtitle: 'ISB Road, Nanakramguda, Hyderabad',
      latitude: 17.4401,
      longitude: 78.3489,
      distance: '9.4 km',
      tag: 'work',
    ),
    AddressModel(
      id: 'addr_airport',
      title: 'Rajiv Gandhi International Airport (RGIA)',
      subtitle: 'Shamshabad, Hyderabad',
      latitude: 17.2403,
      longitude: 78.4294,
      distance: '34 km',
      tag: 'station',
    ),
    AddressModel(
      id: 'addr_banjara',
      title: 'Banjara Hills Road No. 12',
      subtitle: 'Near MLA Colony, Hyderabad',
      latitude: 17.4156,
      longitude: 78.4357,
      distance: '11.2 km',
      tag: 'recent',
    ),
    AddressModel(
      id: 'addr_secunderabad',
      title: 'Secunderabad Railway Station',
      subtitle: 'Station Road, Secunderabad, Telangana',
      latitude: 17.4334,
      longitude: 78.5015,
      distance: '14.5 km',
      tag: 'station',
    ),
  ];

  final Map<String, AddressModel> _savedPlaces = {
    'home': const AddressModel(
      id: 'saved_home',
      title: 'Home',
      subtitle: 'Flat 402, Green Meadows, Kukatpally',
      latitude: 17.4920,
      longitude: 78.3980,
      tag: 'home',
    ),
    'work': const AddressModel(
      id: 'saved_work',
      title: 'Work Office',
      subtitle: 'Building 12, Mindspace, Madhapur',
      latitude: 17.4504,
      longitude: 78.3808,
      tag: 'work',
    ),
  };

  @override
  Future<List<AddressModel>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (query.trim().isEmpty) {
      return getRecentPlaces();
    }

    final lower = query.toLowerCase().trim();
    final results = _allAvailablePlaces.where((place) {
      return place.title.toLowerCase().contains(lower) ||
          place.subtitle.toLowerCase().contains(lower);
    }).toList();

    if (results.isEmpty) {
      return [
        AddressModel(
          id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
          title: query.trim(),
          subtitle: 'Search result in Hyderabad, Telangana',
          distance: 'Nearby',
          tag: 'recent',
        ),
      ];
    }

    return results;
  }

  @override
  Future<List<AddressModel>> getRecentPlaces() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _allAvailablePlaces.take(5).toList();
  }

  @override
  Future<List<AddressModel>> getSavedPlaces() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _savedPlaces.values.toList();
  }

  @override
  Future<void> savePlace(String placeType, AddressModel address) async {
    _savedPlaces[placeType.toLowerCase()] = address;
  }
}
