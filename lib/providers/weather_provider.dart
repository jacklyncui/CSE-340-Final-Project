import 'package:flutter/material.dart';
import 'package:hike_uw/enums/weather_condition.dart';

/// Credit: CSE 340 Assignment 3: Weather @ UW, Spring 2024

/// The provider for Weather
class WeatherProvider extends ChangeNotifier {
  // The current temperature
  int tempInFarenheit = 0;
  // If we have the weather information stored
  bool hasWeather = false;
  // What is the current weather condition at Seattle?
  WeatherCondition condition = WeatherCondition.gloomy;

  /// The method to update the weather with given temperature and condition
  /// and notify the listener of this provider
  /// Parameters:
  ///  - [ newTempFarenheit ] is the temperature at Seattle
  ///  - [ newCondition ] is the weather condition at Seattle
  /// Returns: (none)
  updateWeather(int newTempFarenheit, WeatherCondition newCondition) {
    tempInFarenheit = newTempFarenheit;
    condition = newCondition;
    hasWeather = true;
    notifyListeners();
  }
}
