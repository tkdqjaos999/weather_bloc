import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/src/bloc/bloc.dart';
import 'package:weather_bloc/src/page/weather_search.dart';

import 'data/weather_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        // 블럭을 WeatherSearch페이지 뿐 아니라 네비게이트를 통해 이동한
        // 다른 페이지에서도 사용하고 싶다면 MaterialApp 자체를 BlocProvider로
        // 감싸주어야 한다. 그렇게 한다면 MaterialApp 아래의 모든 루트에서
        // 블럭을 이용가능하다 그렇지만 이 방법은 많은 루트중 적은 수의 루트에서만
        // 블럭을 사용한다면 모든 루트에서 접근이 가능하게 하는 것은 낭비이기 때문에
        // 효율적이지 않다.
        builder: (context) => WeatherBloc(FakeWeatherRepository()),
        child: WeatherSearch(),
      ),
    );
  }
}
