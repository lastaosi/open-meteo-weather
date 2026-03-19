import 'package:equatable/equatable.dart';
import 'weather.dart';

class DailyForecast extends Equatable {
  final String dateIso;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;

  const DailyForecast({
    required this.dateIso,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
  });

  @override
  List<Object?> get props => [dateIso, maxTemp, minTemp, weatherCode];
}

class WeatherDetail extends Equatable {
  final WeatherCurrent current;
  final List<DailyForecast> daily;

  const WeatherDetail({required this.current, required this.daily});

  factory WeatherDetail.fromApi(Map<String, dynamic> json) {
    final current = WeatherCurrent.fromApi(json);

    // daily: time[], temperature_2m_max[], temperature_2m_min[], weather_code[] :contentReference[oaicite:2]{index=2}
    final dailyMap = Map<String, dynamic>.from(json['daily'] as Map);
    final times = List<String>.from(dailyMap['time'] as List);
    final maxs = List<num>.from(dailyMap['temperature_2m_max'] as List);
    final mins = List<num>.from(dailyMap['temperature_2m_min'] as List);
    final codes = List<int>.from(dailyMap['weather_code'] as List);

    final daily = List.generate(times.length, (i) {
      return DailyForecast(
        dateIso: times[i],
        maxTemp: maxs[i].toDouble(),
        minTemp: mins[i].toDouble(),
        weatherCode: codes[i],
      );
    });

    return WeatherDetail(current: current, daily: daily);
  }

  Map<String, dynamic> toMap() => {
    'current': current.toMap(),
    'daily': daily
        .map((e) => {
      'dateIso': e.dateIso,
      'maxTemp': e.maxTemp,
      'minTemp': e.minTemp,
      'weatherCode': e.weatherCode,
    })
        .toList(),
  };

  factory WeatherDetail.fromMap(Map map) => WeatherDetail(
    current: WeatherCurrent.fromMap(Map.from(map['current'] as Map)),
    daily: (map['daily'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((m) => DailyForecast(
      dateIso: m['dateIso'] as String,
      maxTemp: (m['maxTemp'] as num).toDouble(),
      minTemp: (m['minTemp'] as num).toDouble(),
      weatherCode: m['weatherCode'] as int,
    ))
        .toList(),
  );

  @override
  List<Object?> get props => [current, daily];
}
