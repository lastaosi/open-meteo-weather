import 'package:equatable/equatable.dart';

class City extends Equatable {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;

  const City({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  String get displayName {
    final a1 = (admin1 == null || admin1!.isEmpty) ? '' : ' · $admin1';
    final c = (country == null || country!.isEmpty) ? '' : ' · $country';
    return '$name$a1$c';
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'country': country,
    'admin1': admin1,
  };

  factory City.fromMap(Map map) => City(
    id: map['id'] as int,
    name: map['name'] as String,
    latitude: (map['latitude'] as num).toDouble(),
    longitude: (map['longitude'] as num).toDouble(),
    country: map['country'] as String?,
    admin1: map['admin1'] as String?,
  );

  @override
  List<Object?> get props => [id, name, latitude, longitude, country, admin1];
}
