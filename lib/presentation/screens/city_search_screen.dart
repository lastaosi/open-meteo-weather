import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/result.dart';
import '../../data/models/city.dart';
import '../../domain/repositories/city_repository.dart';
import '../providers/city_provider.dart';

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final controller = TextEditingController();
  bool loading = false;
  String? error;
  List<City> results = [];

  Future<void> _search() async {
    final q = controller.text.trim();
    if (q.isEmpty) return;

    setState(() {
      loading = true;
      error = null;
      results = [];
    });

    final repo = context.read<CityRepository>();
    final r = await repo.search(q);

    switch (r) {
      case OK<List<City>>():
        setState(() => results = r.data);
        break;
      case Err<List<City>>():
        setState(() => error = r.error.message);
        break;
    }

    setState(() => loading = false);
  }



  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<CityProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('도시 검색')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: '예) Seoul, Tokyo, 부산',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: loading ? null : _search,
                  child: const Text('검색'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (loading) const LinearProgressIndicator(),
            if (error != null) Text('오류: $error'),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, i) {
                  final c = results[i];
                  final isFav = favProvider.isFavorite(c.id);
                  return ListTile(
                    title: Text(c.displayName),
                    subtitle: Text(
                      'lat ${c.latitude.toStringAsFixed(4)}, lon ${c.longitude.toStringAsFixed(4)}',
                    ),
                    trailing: IconButton(
                      icon: Icon(isFav ? Icons.star : Icons.star_border),
                      onPressed: () async {
                        if (isFav) {
                          await favProvider.removeFavorite(c.id);
                        } else {
                          await favProvider.addFavorite(c);
                        }
                        // 화면은 watch로 자동 갱신됨
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
