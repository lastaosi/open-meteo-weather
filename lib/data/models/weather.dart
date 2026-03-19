import 'package:equatable/equatable.dart';

class WeatherCurrent extends Equatable {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String timeIso;

  const WeatherCurrent({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.timeIso,
  });

  factory WeatherCurrent.fromApi(Map<String, dynamic> json) {
    // Open-Meteo: current={temperature_2m, wind_speed_10m, weather_code, time} 형태 :contentReference[oaicite:1]{index=1}
    final current = Map<String, dynamic>.from(json['current'] as Map);
    return WeatherCurrent(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
      timeIso: current['time'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'temperature': temperature,
    'windSpeed': windSpeed,
    'weatherCode': weatherCode,
    'timeIso': timeIso,
  };

  factory WeatherCurrent.fromMap(Map map) => WeatherCurrent(
    temperature: (map['temperature'] as num).toDouble(),
    windSpeed: (map['windSpeed'] as num).toDouble(),
    weatherCode: map['weatherCode'] as int,
    timeIso: map['timeIso'] as String,
  );

  @override
  List<Object?> get props => [temperature, windSpeed, weatherCode, timeIso];
}
