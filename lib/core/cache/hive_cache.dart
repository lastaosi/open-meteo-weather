import 'package:hive/hive.dart';
import 'cache_entry.dart';

class HiveCache {
  final Box _box;
  final Duration stale;

  HiveCache(this._box,{required this.stale});

  CacheEntry? get(String key){
    final raw = _box.get(key);
    if(raw == null) return null;
    return CacheEntry.fromMap(Map.from(raw as Map));
  }

  bool isFresh(CacheEntry entry){
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - entry.savedAtMillis <= stale.inMilliseconds;
  }

  Future<void> set(String key, Map<String, dynamic> data) async{
    final entry = CacheEntry(savedAtMillis: DateTime.now().millisecondsSinceEpoch, data: data);
    await _box.put(key, entry.toMap());
  }

  Future<void> remove(String key) => _box.delete(key);
}