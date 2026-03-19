import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/city_provider.dart';
import '../providers/weather_list_provider.dart';
import 'city_search_screen.dart';
import 'weather_detail_screen.dart';
import '../ui/weather_code_mapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final cityProvider = context.read<CityProvider>();
      await cityProvider.load();
      await context.read<WeatherListProvider>().refresh(cityProvider.favorites);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = context.watch<CityProvider>();
    final weatherProvider = context.watch<WeatherListProvider>();




    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기 도시 날씨'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CitySearchScreen()),
              );
              // 검색 화면에서 즐겨찾기 추가/삭제 후 돌아오면 갱신
              await context
                  .read<WeatherListProvider>()
                  .refresh(cityProvider.favorites);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<WeatherListProvider>().refresh(cityProvider.favorites),
        child: cityProvider.favorites.isEmpty
            ? ListView(
          children: const [
            SizedBox(height: 120),
            Center(child: Text('오른쪽 위 검색으로 도시를 추가해봐')),
          ],
        )
            : ListView.builder(
          itemCount: weatherProvider.items.length,
          itemBuilder: (context, index) {
            final item = weatherProvider.items[index];
            final current = item.current;
            final ui = current != null
                ? mapWeatherCode(current.weatherCode)
                : null;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: current == null
                    ? null // 에러 상태면 상세 진입 막기
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WeatherDetailScreen(
                        city: item.city,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        ui?.icon ?? Icons.cloud_off,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    title: Text(
                      item.city.displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: current != null
                        ? Text(
                      '${ui!.labelKo} · 바람 ${current.windSpeed.toStringAsFixed(1)} m/s',
                    )
                        : Text(
                      '오류: ${item.error}',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                    trailing: current != null
                        ? Text(
                      '${current.temperature.toStringAsFixed(1)}°',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        await context
                            .read<WeatherListProvider>()
                            .refresh(cityProvider.favorites);
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
