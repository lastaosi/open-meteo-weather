import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/city.dart';
import '../providers/weather_detail_provider.dart';

class WeatherDetailScreen extends StatefulWidget {
  final City city;
  const WeatherDetailScreen({super.key, required this.city});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WeatherDetailProvider>().load(
        cityId: widget.city.id,
        lat: widget.city.latitude,
        lon: widget.city.longitude,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<WeatherDetailProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.city.displayName)),
      body: p.loading
          ? const Center(child: CircularProgressIndicator())
          : (p.error != null)
          ? Center(child: Text('오류: ${p.error}'))
          : (p.detail == null)
          ? const Center(child: Text('데이터 없음'))
          : ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('현재', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    '기온 ${p.detail!.current.temperature.toStringAsFixed(1)}°C',
                  ),
                  Text(
                    '바람 ${p.detail!.current.windSpeed.toStringAsFixed(1)}m/s',
                  ),
                  Text('weather_code ${p.detail!.current.weatherCode}'),
                  Text('time ${p.detail!.current.timeIso}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text('7일 예보', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          ...p.detail!.daily.map((d) {
            return ListTile(
              title: Text(d.dateIso),
              subtitle: Text(
                '최고 ${d.maxTemp.toStringAsFixed(1)}°C / 최저 ${d.minTemp.toStringAsFixed(1)}°C · code ${d.weatherCode}',
              ),
            );
          }),
        ],
      ),
    );
  }
}
