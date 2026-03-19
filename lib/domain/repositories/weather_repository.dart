import 'package:dio/dio.dart';

import '../../core/app_error.dart';
import '../../core/result.dart';
import '../../core/cache/hive_cache.dart';
import '../../data/models/weather.dart';
import '../../data/models/weather_detail.dart';
import '../../data/sources/open_meteo_api.dart';

class WeatherRepository {
  final OpenMeteoApi api;
  final HiveCache cache;

  WeatherRepository({required this.api, required this.cache});

  String _currentKey(int cityId) => 'current_$cityId';
  String _detailKey(int cityId)=>'detail_$cityId';

  Future<Result<WeatherCurrent>> getCurrent({
    required int cityId,
    required double lat,
    required double lon,
  }) async {
    try{
      final key = _currentKey(cityId);
      final entry = cache.get(key);
      if(entry  != null && cache.isFresh(entry)){
        return OK(WeatherCurrent.fromMap(entry.data));
      }

      final json = await api.fetchCurrent(lat, lon);
      final current = WeatherCurrent.fromApi(json);
      await cache.set(key, current.toMap());
      return OK(current);
    }on DioException catch(e){
      return Err(AppError(AppErrorType.network, e.message ?? '네트워크 오류'));
    }catch(e){
      return Err(AppError(AppErrorType.unknown, '현재 날씨 조회 실패: $e'));
    }
  }

  Future<Result<WeatherDetail>> getDetail({
    required int cityId,
    required double lat,
    required double lon
  }) async{
    try{
      final key = _detailKey(cityId);
      final entry = cache.get(key);
      if(entry != null && cache.isFresh(entry)){
        return OK(WeatherDetail.fromMap(entry.data));
      }

      final json = await api.fetchDetail(lat, lon);
      final detail = WeatherDetail.fromApi(json);
      await cache.set(key, detail.toMap());
      return OK(detail);

    }on DioException catch(e){
      return Err(AppError(AppErrorType.network, e.message ?? '네트워크 오류'));
    }catch(e){
      return Err(AppError(AppErrorType.unknown,'상세 날씨 조회 실페:$e'));
    }
  }


}