import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../data/models/city.dart';

class CityProvider extends ChangeNotifier{
  final Box favoriteBox;

  CityProvider(this.favoriteBox);

  List<City> _favorites = [];
  List<City> get favorites => _favorites;

  Future<void> load() async{
    final values = favoriteBox.values
        .map((e) => City.fromMap(Map.from(e as Map)));
    _favorites = values.toList();
    notifyListeners();
  }

  bool isFavorite(int cityId) => _favorites.any((c)=> c.id == cityId);

  Future<void> addFavorite(City city) async {
    if(isFavorite(city.id)) return;
    await favoriteBox.put(city.id, city.toMap());
    await load();
  }

  Future<void> removeFavorite(int cityId) async{
    await favoriteBox.delete(cityId);
    await load();
  }
}
