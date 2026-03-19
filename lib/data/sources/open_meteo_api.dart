import 'package:dio/dio.dart';

class OpenMeteoApi{
  final Dio _dio;
  OpenMeteoApi(this._dio);

  // ㅈㅣ오코딩 : https://geocoding-api.open-meteo.com/v1/search?name=seoul
  Future<Map<String,dynamic>> searchCity(String query) async {
    final res = await _dio.get(
      'https://geocoding-api.open-meteo.com/v1/search',
      queryParameters: {
        'name' : query,
        'count' : 20,
        'language' : 'ko',
        'format' : 'json'
      }
    );
    return Map<String,dynamic>.from(res.data as Map);
  }

  // 날씨: https://api.open-meteo.com/v1/forecast?latitude=..&longitude=.. :contentReference[oaicite:4]{index=4}
  Future<Map<String, dynamic>> fetchCurrent(double lat, double lon) async {
    final res = await _dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'timezone': 'auto',
        'current': 'temperature_2m,wind_speed_10m,weather_code',
        // 리스트는 "현재"만 필요하니 daily는 안 붙임
      },
    );
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<Map<String, dynamic>> fetchDetail(double lat, double lon) async {
    final res = await _dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': lat,
        'longitude': lon,
        'timezone': 'auto',
        'forecast_days': 7,
        'current': 'temperature_2m,wind_speed_10m,weather_code',
        'daily': 'temperature_2m_max,temperature_2m_min,weather_code',
      },
    );
    return Map<String, dynamic>.from(res.data as Map);
  }
}