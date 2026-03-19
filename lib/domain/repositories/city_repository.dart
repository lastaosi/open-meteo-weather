import '../../core/result.dart';
import '../../core/app_error.dart';
import '../../data/models/city.dart';
import '../../data/sources/open_meteo_api.dart';
import 'package:dio/dio.dart';

class CityRepository {
  final OpenMeteoApi api;
  CityRepository(this.api);

  Future<Result<List<City>>> search(String query) async{
    try{
      final q1 = normalizeQuery(query);

      final json1 = await api.searchCity(query);
      final cities1 = _parseCities(json1);
      if(cities1.isNotEmpty){
        return OK(cities1);
      }

      final alias = koToEnAlias[q1];
      if(alias == null){
        return OK([]);
      }

      final json2 = await api.searchCity(alias);
      final cities2 = _parseCities(json2);

      final merged = { for(final c in cities2) c.id : c}.values.toList();
      return OK(merged);

    }on DioException catch(e){
      return Err(AppError(AppErrorType.network,e.message ?? '네트워크오류'));
    } catch(e){
      return Err(AppError(AppErrorType.parsing,'도시 검색 파싱 실패: $e'));
    }

  }

  String normalizeQuery(String q){
    var s = q.trim();
    s = s.replaceAll(RegExp(r'\s+'), ' ');

    s = s.replaceAll('특별시', '');
    s = s.replaceAll('광역시', '');
    s = s.replaceAll('시', '');
    s = s.replaceAll('군', '');
    s = s.replaceAll('구', '');

    return s.trim();
  }

  List<City> _parseCities(Map<String, dynamic> json) {
    final results = (json['results'] as List?) ?? [];

    return results.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return City(
        id: m['id'] as int,
        name: m['name'] as String,
        latitude: (m['latitude'] as num).toDouble(),
        longitude: (m['longitude'] as num).toDouble(),
        country: m['country'] as String?,
        admin1: m['admin1'] as String?,
      );
    }).toList();
  }

  static const koToEnAlias = {
    '서울': 'seoul',
    '부산': 'busan',
    '대구': 'daegu',
    '인천': 'incheon',
    '광주': 'gwangju',
    '대전': 'daejeon',
    '울산': 'ulsan',
    '세종': 'sejong',
    '제주': 'jeju',
  };
}