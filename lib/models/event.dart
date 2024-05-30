import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'event.g.dart';

typedef UUIDString = String;

/// Event is the class for a specific event
@HiveType(typeId: 0)
class Event {
  /// [ description ] is a String to describe the event
  @HiveField(0)
  final String description;

  /// [ uuid ] is a UUIDString (a.k.a. String), as the unique identifier for an event
  @HiveField(1)
  final UUIDString uuid;

  /// [ date ] is a DateTime to store the date of event
  @HiveField(2)
  final DateTime date;

  /// [ startTime ] is a TimeOfDay to store the starting time of the event
  @HiveField(3)
  final TimeOfDay startTime;

  /// [ endTime ] is a TimeOfDay to store the ending time of the event
  @HiveField(4)
  final TimeOfDay endTime;

  /// The unnamed constructor of Event
  /// It is used for Hive to restore the events
  /// Parameters:
  ///  - [ uuid ], [ description ], [ date ], [ startTime ], [ endTime ] are all required named parameters
  ///  and the meaning of each parameter is given in the documentation of data fields
  /// Returns: A new instance of Event with all given information
  Event({
    required this.uuid,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  /// The named constructor of Event with name Event.newEvent
  /// It is used to create a new event
  /// Parameters:
  ///  - [ uuid ], [ description ], [ date ], [ startTime ], [ endTime ] are all required named parameters
  /// and the meaning of each parameter is given in the documentation of data fields
  /// Returns: A new instance of Event with all given information except for a random assigned uuid
  Event.newEvent({
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  }) : uuid = UUIDMaker.generateUUID();

  /// Also we may choose to support deleting an event
  Event.updated(
    Event oldEntry, {
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
  }) : uuid = oldEntry.uuid;
}

/// `UUIDMaker` is used to generate a random UUID
class UUIDMaker {
  /// `uuid` as UUIDString (a.k.a. String) for the unique identifier
  static const uuid = Uuid();

  /// Generate an unique UUID using `uuid.dart`
  /// Parameters: (none)
  /// Return: A random, unique UUID
  static UUIDString generateUUID() {
    return uuid.v4();
  }
}
