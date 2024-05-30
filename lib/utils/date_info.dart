/// This class contains a very stupid approach to get the date info (but it works)
class DateInfo {
  /// This static method returns a string for the information of the given date
  /// It make use of two methods, [ _getQuarterInfo ] and [ _getWeekInfo ].
  /// Parameter:
  ///  - [ currentDate ] is the DateTime presenting the current date information
  /// Returns: A String including the information of the current date
  static String getDateInfo(DateTime currentDate) {
    return '${_getWeekInfo(currentDate)} · ${_getQuarterInfo(currentDate)}';
  }

  /// This static method returns a string for the quarter info of the given date
  /// Parameter:
  ///  - [ currentDate ] is the DateTime presenting the current date information
  /// Returns: A String including the quarter information of the current date
  static String _getQuarterInfo(DateTime currentDate) {
    if (currentDate.isBefore(DateTime(2024, 6, 8))) {
      return 'Spring 2024';
    } else if (currentDate.isAfter(DateTime(2024, 6, 17)) &&
        currentDate.isBefore(DateTime(2024, 7, 18))) {
      return 'Summer A 2024';
    } else if (currentDate.isAfter(DateTime(2024, 7, 18)) &&
        currentDate.isBefore(DateTime(2024, 8, 17))) {
      return 'Summer B 2024';
    } else if (currentDate.isAfter(DateTime(2024, 9, 25)) &&
        currentDate.isBefore(DateTime(2024, 12, 14))) {
      return 'Autumn 2024';
    } else {
      return 'Quarter Break';
    }
  }

  /// This static method returns a string for the week info of the given date
  /// Parameter:
  ///  - [ currentDate ] is the DateTime presenting the current date information
  /// Returns: A String including the week information of the current date
  static String _getWeekInfo(DateTime currentDate) {
    if (currentDate.isBefore(DateTime(2024, 5, 26))) {
      return 'Week 9 of 10';
    } else if (currentDate.isBefore(DateTime(2024, 6, 1))) {
      return 'Week 10 of 10';
    } else if (currentDate.isBefore(DateTime(2024, 6, 8))) {
      return 'Final Week';
    } else if (currentDate.isBefore(DateTime(2024, 6, 17))) {
      return 'Quarter Break';
    } else if (currentDate.isBefore(DateTime(2024, 6, 23))) {
      return 'Week 1 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 6, 30))) {
      return 'Week 2 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 7, 7))) {
      return 'Week 3 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 7, 14))) {
      return 'Week 4 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 7, 18))) {
      return 'Week 5 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 7, 21))) {
      return 'Week 1 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 7, 28))) {
      return 'Week 2 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 8, 4))) {
      return 'Week 3 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 8, 11))) {
      return 'Week 4 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 8, 17))) {
      return 'Week 5 of 5';
    } else if (currentDate.isBefore(DateTime(2024, 9, 25))) {
      return 'Quarter Break';
    } else {
      return '';
    }
  }
}
