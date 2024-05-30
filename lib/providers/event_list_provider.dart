import 'package:flutter/material.dart';
import 'package:hike_uw/models/event_list.dart';
import 'package:hike_uw/models/event.dart';
import 'package:hike_uw/widgets/homepage_event_widget.dart';

/// The provider for all events
class EventListProvider extends ChangeNotifier {
  /// The whole list of events
  final EventList _eventList;

  /// The unnamed constructor for EventListProvider
  /// Restore the information based on the information from Hive
  /// Parameter:
  ///  - [ boxForEventEntries ] is the Box of event from Hive
  /// Returns: A new instance of EventListProvider()
  EventListProvider(boxForEventEntries)
      : _eventList = EventList.restore(storage: boxForEventEntries);

  /// Getter for all entries and it returns a shallow copy of all entries
  List<Event> get entries => List.from(_eventList.entries);

  /// Insert a new Event to [ _eventList ] by calling the method in [ EventList ]
  /// Parameter:
  ///  - [ entry ] is the instance of Event to put into [ _eventList ], it is a required positional parameter.
  /// Returns: The [ _eventList ] with given updated entry
  upsertEventEntry(Event entry) {
    _eventList.upsertEntry(entry);
    notifyListeners();
    return _eventList;
  }

  /// Remove the Event from [ _eventList ] by calling the method in [ EventList ]
  /// Parameter:
  ///  - [ entry ] is the instance of Event to delete from [ _eventList ], it is a required positional parameter.
  /// Returns: (none)
  removeEvent(Event entry) {
    _eventList.removeEvent(entry);
    notifyListeners();
  }

  /// The method helps to build todo lists based on events from [ _eventList ]
  /// Parameter: (none)
  /// Returns: A Column() of widgets of todo events based on the information from [ _eventList ]
  Widget build() {
    /// Shallow copy of events
    List<Event> allEvents = List.from(_eventList.entries);

    /// Sort the events based on the time from now
    allEvents.sort(
      (a, b) {
        if (a.date.compareTo(b.date) == 0) {
          // Same date, sort by duration and start time
          int startTimeOfA = a.startTime.hour * 60 + a.startTime.minute;
          int endTimeOfA = a.endTime.hour * 60 + a.endTime.minute;
          int startTimeOfB = b.startTime.hour * 60 + b.startTime.minute;
          int endTimeOfB = b.endTime.hour * 60 + b.endTime.minute;
          if (startTimeOfA - startTimeOfB != 0) {
            // Different Start time
            return (startTimeOfA - startTimeOfB);
          } else {
            // Same start time, judge their duration
            return ((endTimeOfA - startTimeOfA) - (endTimeOfB - startTimeOfB));
          }
        } else {
          // Different dates
          return a.date.compareTo(b.date);
        }
      },
    );

    // Filter events that their dates were prior to today
    DateTime currentDate = DateTime.now();
    List<Event> futureEvents = allEvents.fold(
      [],
      (preVal, curVal) => currentDate.compareTo(DateTime(
                  curVal.date.year,
                  curVal.date.month,
                  curVal.date.day,
                  curVal.startTime.hour,
                  curVal.startTime.minute)) <
              0
          ? [...preVal, curVal]
          : [],
    );

    // Keep up to 5 events to build
    List<Event> eventsToBuild = futureEvents.fold([],
        (preVal, curVal) => preVal.length >= 5 ? preVal : [...preVal, curVal]);

    // Use filtered events to build widgets
    List<Widget> listOfEvents = eventsToBuild.fold(
      [],
      (preVal, curVal) => [
        ...preVal,
        HomepageEventWidget(event: curVal),
      ],
    );

    // Return the content based on the data from eventsToBuild
    // If eventsToBuild has nothing, then show "Nothing planned"
    // Otherwise show the message and the todos in a column
    return Container(
      padding: const EdgeInsets.all(10),
      child: switch (futureEvents.length) {
        0 => const Text(
            ////////////////////////////////
            // Beginning: Nothing planned //
            ////////////////////////////////
            'Good news! You have nothing planned in the future!',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            //////////////////////////
            // End: Nothing planned //
            //////////////////////////
          ),
        1 => Column(
            ///////////////////////////////////////
            // Beginning: only one thing planned //
            ///////////////////////////////////////
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Here is ${listOfEvents.length} thing planned in the future:',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...listOfEvents
            ],
            /////////////////////////////////
            // End: only one thing planned //
            /////////////////////////////////
          ),
        2 || 3 || 4 || 5 => Column(
            ///////////////////////////////////////////
            // Beginning: Some things (<= 5) planned //
            ///////////////////////////////////////////
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Here are ${listOfEvents.length} things planned in the future:',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...listOfEvents
            ],
            /////////////////////////////////////
            // End: Some things (<= 5) planned //
            /////////////////////////////////////
          ),
        _ => Column(
            //////////////////////////////////////////
            // Beginning: Some things (> 5) planned //
            //////////////////////////////////////////
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have ${futureEvents.length} things planned in the future.\nHere are the nearest ${listOfEvents.length} of them.',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...listOfEvents
            ],
            ////////////////////////////////////
            // End: Some things (> 5) planned //
            ////////////////////////////////////
          ),
      },
    );
  }
}
