import 'dart:math';

import 'weather.dart';

import 'package:weather_bloc/data/weather.dart';

// bloc을 사용하기 위해서는 3가지 파일이 필요하다
// weather event, weather state, weather bloc
// bloc 플러그인을 만들면
// bloc.dart, ***_bloc, ***_event, ***_state 파일을
// 자동생성해준다.
abstract class WeatherRepository {
  Future<Weather> fetchWeather(String cityName);

  Future<Weather> fetchDetailWeather(String cityName);
}

class FakeWeatherRepository implements WeatherRepository {
  double cachedTempCelsius;

  @override
  Future<Weather> fetchDetailWeather(String cityName) {
    // TODO: implement fetchDetailWeather
    return Future.delayed(Duration(seconds: 1), () {
      return Weather(
          cityName: cityName,
          temperatureCelsius: cachedTempCelsius,
          temperatureFahrenheit: cachedTempCelsius * 1.8 + 32);
    });
  }

  @override
  Future<Weather> fetchWeather(String cityName) {
    // TODO: implement fetchWether
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();

      if (random.nextBool()) {
        throw NetworkError();
      }

      cachedTempCelsius = 20 + random.nextInt(15) + random.nextDouble();

      return Weather(cityName: cityName, temperatureCelsius: cachedTempCelsius);
    });
  }
}

class NetworkError extends Error {}
