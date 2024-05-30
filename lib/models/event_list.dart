import 'package:hike_uw/models/event.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// The whole list of events
class EventList {
  late List<Event> _entries; // The whole list of events
  late final Box<Event> _storage; // The storage from Hive for events

  /// Constructor for cloning event list with given EventList
  /// Parameter:
  ///  - [ toCopy ] is the EventList to copy from, it is a required named parameter.
  /// Returns: A new instance of EventList with shallow copy of all events
  EventList.clone({required EventList toCopy})
      : _entries = List.from(toCopy._entries),
        _storage = toCopy._storage;

  /// Construcor for restoring all the events from Hive
  /// Parameter:
  ///  - [ storage ] is the Box for Events from Hive, it is a required named parameter.
  /// Returns: A new instance of EventList with all events from storage in the Box
  EventList.restore({required Box<Event> storage}) {
    _storage = storage;
    _entries = storage.values.toList();
  }

  /// Getter for all entries and it returns a shallow copy of [ _entries]
  List<Event> get entries => List.from(_entries);

  /// Delete the event from the whole list, including the box
  /// Parameter:
  ///  - [ event ] is the event to delete
  /// Returns: (null)
  removeEvent(Event event) {
    _entries.remove(event);
    _storage.delete(event.description);
  }

  /// Insert a new Event to [ _entries ] by checking the data field [ Event.uuid ]
  /// If there is an element with same uuid, update the item
  /// Otherwise, add it to [ _entries ] and put it into the HiveBox
  /// Parameter:
  ///  - [ entry ] is the instance of Event to put into [ _entries], it is a required positional parameter.
  /// Returns: (none)
  upsertEntry(Event entry) {
    // bool to check if [ _entries ] is updated
    bool isUpdated = false;

    // Use List.fold to update the list
    _entries = _entries.fold(
      [],
      (preVal, element) {
        if (element.uuid == entry.uuid) {
          // element with same uuid
          isUpdated = true;
          return [...preVal, entry];
        } else {
          // element with different uuid
          return [...preVal, element];
        }
      },
    );

    // if not updated, then add to the end of entries
    if (!isUpdated) _entries.add(entry);

    // Put the entry into the storage from Hive
    _storage.put(entry.uuid, entry);
  }
}
