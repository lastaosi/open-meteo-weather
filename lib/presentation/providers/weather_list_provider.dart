import 'package:flutter/foundation.dart';
import '../../core/result.dart';
import '../../data/models/city.dart';
import '../../data/models/weather.dart';
import '../../domain/repositories/weather_repository.dart';

class CityWeatherItem{
  final City city;
  final WeatherCurrent? current;
  final String? error;

  CityWeatherItem({required this.city, this.current, this.error});
}

class WeatherListProvider extends ChangeNotifier{
  final WeatherRepository repo;

  WeatherListProvider(this.repo);

  bool loading = false;
  List<CityWeatherItem> items = [];

  Future<void> refresh(List<City> favorites) async{
    loading = true;
    notifyListeners();
    final results = <CityWeatherItem>[];
    for(final city in favorites){
      final r = await repo.getCurrent(cityId: city.id, lat: city.latitude, lon: city.longitude);

      switch(r){
        case OK<WeatherCurrent>():
          results.add(CityWeatherItem(city: city, current: r.data));
          break;
        case Err<WeatherCurrent>():
          results.add(CityWeatherItem(city: city,error: r.error.message));
          break;
      }
    }

    items = results;
    loading = false;
    notifyListeners();
  }

}