import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/data/weather.dart';
import 'package:weather_bloc/src/bloc/bloc.dart';

class WeatherDetailPage extends StatefulWidget {
  final Weather masterWeather;

  const WeatherDetailPage({Key key, this.masterWeather}) : super(key: key);

  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // BlocProvider의 add 호출은 위젯이 만들어지고 스테이트가 처음 시작될때
    // 한번만 add를 호출하면 된다. 따라서 statefulWidget을 사용하고
    // didChageDependencies내부에 add를호출을 해주면 된다.
    BlocProvider.of<WeatherBloc>(context)
      ..add(GetDetailedWeather(widget.masterWeather.cityName));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Detail'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        alignment: Alignment.center,
        child:
            BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
          if (state is WeatherLoading) {
            return _buildLoading();
          } else if (state is WeatherLoaded) {
            return _buildColumnWithData(context, state.weather);
          }
        }),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildColumnWithData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
        Text("${weather.temperatureCelsius.toStringAsFixed(1)} 'C", textScaleFactor: 5.0,),
        Text("${weather.temperatureFahrenheit.toStringAsFixed(1)} 'F", textScaleFactor: 5.0)
        //_cityInputField(),
      ],
    );
  }
}
