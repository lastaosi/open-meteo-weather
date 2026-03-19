import 'package:flutter/foundation.dart';

import '../../core/result.dart';
import '../../data/models/weather_detail.dart';
import '../../domain/repositories/weather_repository.dart';

class WeatherDetailProvider extends ChangeNotifier {
  final WeatherRepository repo;
  WeatherDetailProvider(this.repo);

  bool loading = false;
  WeatherDetail? detail;
  String? error;

  Future<void> load({
    required int cityId,
    required double lat,
    required double lon,
  }) async {
    loading = true;
    error = null;
    notifyListeners();

    final r = await repo.getDetail(cityId: cityId, lat: lat, lon: lon);

    switch (r) {
      case OK<WeatherDetail>():
        detail = r.data;
        break;
      case Err<WeatherDetail>():
        error = r.error.message;
        break;
    }

    loading = false;
    notifyListeners();
  }
}
