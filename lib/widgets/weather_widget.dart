import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hike_uw/enums/weather_condition.dart';
import 'package:hike_uw/providers/weather_provider.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherProvider weatherProvider;

  const WeatherWidget({super.key, required this.weatherProvider});

  @override
  Widget build(BuildContext context) {
    final iconToShow = switch (weatherProvider.condition) {
      WeatherCondition.gloomy => FontAwesomeIcons.cloud,
      WeatherCondition.sunny => FontAwesomeIcons.sun,
      WeatherCondition.rainy => FontAwesomeIcons.cloudRain,
    };

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${weatherProvider.tempInFarenheit} °F | '),
          WidgetSpan(
            child: Icon(
              iconToShow,
              size: 16,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
