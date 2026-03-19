import 'package:flutter/material.dart';

class WeatherUi{
  final String labelKo;
  final IconData  icon;
  const WeatherUi(this.labelKo,this.icon);


}

WeatherUi mapWeatherCode(int code){
  if(code ==0 ) return const WeatherUi('맑음', Icons.wb_sunny_outlined);
  if (code == 1 || code == 2) return const WeatherUi('대체로 맑음', Icons.wb_sunny);
  if (code == 3) return const WeatherUi('흐림', Icons.cloud_outlined);

  if (code == 45 || code == 48) return const WeatherUi('안개', Icons.blur_on);

  if (code == 51 || code == 53 || code == 55) return const WeatherUi('이슬비', Icons.grain);
  if (code == 56 || code == 57) return const WeatherUi('어는 이슬비', Icons.grain);

  if (code == 61 || code == 63 || code == 65) return const WeatherUi('비', Icons.umbrella_outlined);
  if (code == 66 || code == 67) return const WeatherUi('어는 비', Icons.umbrella);

  if (code == 71 || code == 73 || code == 75) return const WeatherUi('눈', Icons.ac_unit);
  if (code == 77) return const WeatherUi('싸락눈', Icons.ac_unit_outlined);

  if (code == 80 || code == 81 || code == 82) return const WeatherUi('소나기', Icons.beach_access_outlined);

  if (code == 85 || code == 86) return const WeatherUi('눈 소나기', Icons.ac_unit);

  if (code == 95) return const WeatherUi('뇌우', Icons.flash_on);
  if (code == 96 || code == 99) return const WeatherUi('강한 뇌우/우박', Icons.flash_on_outlined);

  return const WeatherUi('알 수 없음', Icons.help_outline);

}