import 'package:flutter/material.dart';

/// The provider for selecting time for event
class EventInfoProvider extends ChangeNotifier {
  /// The name of the event
  String name;

  /// The date for the event
  DateTime selectedDay;

  /// The starting time for the event
  TimeOfDay selectedStartTime;

  /// The ending time for the event
  TimeOfDay selectedEndTime;

  /// Unnamed constructor and initializing the date, starting time, ending time to be now
  EventInfoProvider()
      : name = '',
        selectedDay = DateTime.now(),
        selectedStartTime = TimeOfDay.now(),
        selectedEndTime = TimeOfDay.now();

  /// Setter for the date, also notify the listerners
  /// Parameter:
  ///  - [ date ] is a DateTime as the selected date
  selectDate(DateTime date) {
    selectedDay = date;
    notifyListeners();
  }

  /// Setter for the start time, also notify the listerners
  /// Parameter:
  ///  - [ time ] is a TimeOfDay as the start time of event
  selectStartTime(TimeOfDay time) {
    selectedStartTime = time;
    notifyListeners();
  }

  /// Setter for the end time, also notify the listerners
  /// Parameter:
  ///  - [ time ] is a TimeOfDay as the end time of event
  selectEndTime(TimeOfDay time) {
    selectedEndTime = time;
    notifyListeners();
  }
}
