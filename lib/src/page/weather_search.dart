import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/data/weather.dart';
import 'package:weather_bloc/src/bloc/bloc.dart';
import 'package:weather_bloc/src/page/weather_detail.dart';

class WeatherSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Search'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocListener<WeatherBloc, WeatherState>(
          // 빌더와 리스너를 구분하는 이유
          // 빌더는 state가 변화하지 않아도 UI를 여러번 빌드한다
          // 리스너는 state 변화당 1번만 실행한다.
          listener: (context, state) {
            if (state is WeatherError) {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child:
              BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
            // builder 함수내에는 위젯들만 리턴할 수 있다.
            // 스낵바와 같은 side effect를 사용하고 싶으면 Bloc Listener을 이용해야 한다.
            if (state is WeatherInitial) {
              return _buildInitialInput();
            } else if (state is WeatherLoading) {
              return _buildLoading();
            } else if (state is WeatherLoaded) {
              return _buildColumnWithData(context, state.weather);
            } else if (state is WeatherError) {
              return _buildInitialInput();
            }
          }),
        ),
      ),
    );
  }

  Widget _buildInitialInput() {
    return Center(
      child: _cityInputField(),
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
        Text("${weather.temperatureCelsius.toStringAsFixed(1)} 'C"),
        RaisedButton(
            child: Text('See Details'),
            color: Colors.lightBlue[100],
            onPressed: () {
              // 네비게이터를 통해 페이지를 이동했을 때 이전 페이지에서 사용한
              // BlocProvider를 이용하고 싶다면 BlocProvider.value를 사용해야 한다.
              // 머티리얼페이지루트의 빌더에 (_) => BlocProvider.value를 입력한다
              // 그리고 value값은 현재 컨텍스트의 BlocProvider를, 그리고
              // child에 다음 페이지를 입력한다.
              // 다음 페이지 루트에서 BlocProvider를 사용해 위젯을 감싸 사용한다면
              // 새로운 프로바이더가 만들어져 이전과 아예 다른 블럭을 사용하게 된다.
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<WeatherBloc>(context),
                      child: WeatherDetailPage(
                        masterWeather: weather,
                      ),
                    ),
                  ));
            }),
        _cityInputField(),
      ],
    );
  }
}

class _cityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Enter a city',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(GetWeather(cityName));
  }
}
