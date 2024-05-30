import 'package:flutter/material.dart';
import 'package:hike_uw/providers/weather_provider.dart';
import 'package:hike_uw/utils/date_info.dart';
import 'package:hike_uw/widgets/weather_widget.dart';

class WeekWeatherWidget extends StatelessWidget {
  final WeatherProvider weatherProvider;

  const WeekWeatherWidget({super.key, required this.weatherProvider});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.primaryColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                // Week and quarter information
                DateInfo.getDateInfo(DateTime.now()),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.primaryColor,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              // Weather information
              child: WeatherWidget(
                weatherProvider: weatherProvider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
