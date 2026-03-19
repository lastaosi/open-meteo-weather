import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/dio_client.dart';
import 'core/cache/hive_cache.dart';
import 'data/sources/open_meteo_api.dart';
import 'domain/repositories/city_repository.dart';
import 'domain/repositories/weather_repository.dart';
import 'presentation/providers/city_provider.dart';
import 'presentation/providers/weather_detail_provider.dart';
import 'presentation/providers/weather_list_provider.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final favoritesBox = await Hive.openBox('favoritesBox');
  final cacheBox = await Hive.openBox('cacheBox');

  final dio = DioClient().dio;
  final api = OpenMeteoApi(dio);
  final cache = HiveCache(cacheBox, stale: const Duration(minutes: 10));

  runApp(
  MultiProvider(
    providers: [
      Provider<CityRepository>(create: (_) => CityRepository(api)),
      Provider<WeatherRepository>(
        create: (_) => WeatherRepository(api: api, cache: cache),
      ),
      ChangeNotifierProvider(create: (context) => CityProvider(favoritesBox)),
      ChangeNotifierProvider(create: (context) => WeatherListProvider(
        context.read<WeatherRepository>(),
      )),
      ChangeNotifierProvider(create: (context) => WeatherDetailProvider(
        context.read<WeatherRepository>(),
      )),
    ],
    child: const MyApp(),
  ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open-Meteo Weather',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
