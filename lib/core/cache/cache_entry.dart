class CacheEntry {
  final int savedAtMillis;
  final Map<String, dynamic> data;

  CacheEntry({required this.savedAtMillis, required this.data});

  Map<String,dynamic> toMap() => {
    'savedAtMillis' : savedAtMillis,
    'data' : data,
  };

  factory CacheEntry.fromMap(Map map) => CacheEntry(
      savedAtMillis: map['savedAtMillis'] as int,
      data: Map<String,dynamic>.from(map['data'] as Map));
}
