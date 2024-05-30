import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hike_uw/models/event.dart';
import 'package:hike_uw/widgets/event_widget.dart';
import 'package:intl/intl.dart';
import 'package:hike_uw/providers/event_list_provider.dart';
import 'package:hike_uw/providers/event_info_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

/// A page that displays a calendar with lists of event for selected days
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EventListProvider, EventInfoProvider>(
      builder: (context, eventListProvider, eventInfoProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(eventInfoProvider.selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(
                    () {
                      eventInfoProvider.selectDate(selectedDay);
                      _focusedDay = focusedDay;
                    },
                  );
                },
                onFormatChanged: (format) {
                  setState(
                    () {
                      _calendarFormat = format;
                    },
                  );
                },
                eventLoader: (day) {
                  final eventsForDay = eventListProvider.entries.where(
                    (event) {
                      final isSameDate = event.date.year == day.year &&
                          event.date.month == day.month &&
                          event.date.day == day.day;
                      return isSameDate;
                    },
                  ).toList();
                  return eventsForDay;
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(fontSize: 20), // Set the desired font size here
                      ),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.purple,
                          border: Border.all(color: Colors.purple, width: 2),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(fontSize: 20, color: Colors.white, 
                          fontWeight: FontWeight.bold), // Set the desired font size and styling for today here
                        ),
                      ),
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(fontSize: 20, color: Colors.white, 
                          fontWeight: FontWeight.bold), // Set the desired font size and styling for today here
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildEventList(eventListProvider, eventInfoProvider),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                _addEventDialog(context, eventListProvider, eventInfoProvider),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  /// Builds a list of events for the selected day
  Expanded _buildEventList(EventListProvider eventListProvider,
      EventInfoProvider eventInfoProvider) {
    final eventsForSelectedDay = eventListProvider.entries
        .where(
          (event) => isSameDay(event.date, eventInfoProvider.selectedDay),
        )
        .toList();

    return Expanded(
      child: ListView(
        children: eventsForSelectedDay
            .map(
              (event) => GestureDetector(
                onLongPressStart: (LongPressStartDetails details) {
                  showMenu(
                    items: <PopupMenuEntry>[
                      PopupMenuItem(
                        child: const Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.trash),
                            Text(' Delete'), // option to delete the event
                          ],
                        ),
                        onTap: () {
                          _removeEvent(context, event);
                        },
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: <Widget>[
                            Icon(FontAwesomeIcons.pen),
                            Text(' Modify'), // option to modify the event
                          ],
                        ),
                        onTap: () {
                          _modifyEvent(
                            context,
                            event,
                            eventListProvider,
                            eventInfoProvider,
                          );
                        },
                      ),
                    ],
                    position: RelativeRect.fromLTRB(
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                      details.globalPosition.dx,
                      details.globalPosition.dy,
                    ),
                    context: context,
                  );
                },
                child: EventWidget(event: event),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Show a dialog for adding a new event
  void _addEventDialog(
      BuildContext context,
      EventListProvider eventListProvider,
      EventInfoProvider eventTimeSelectionProvider) {
    showDialog(
      context: context,
      builder: (context) => _buildNewEventDialog(context, eventListProvider),
    );
  }

  /// Builds a dialog for creating a new event
  _buildNewEventDialog(
    BuildContext context,
    EventListProvider eventListProvider,
  ) {
    EventInfoProvider eventInfoProvider =
        Provider.of<EventInfoProvider>(context);

    String currentText = eventInfoProvider.name;

    TextEditingController eventNameController = 
      TextEditingController(text: currentText);
    ThemeData theme = Theme.of(context);

    // Alert for an event entry
    return AlertDialog(
      title: const Text('Add Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (text) {
              currentText = text;
              eventInfoProvider.name = text;
            },
            decoration: const InputDecoration(labelText: 'Event Description'),
            controller: eventNameController,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(FontAwesomeIcons.calendar),
              Expanded(
                child: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: eventInfoProvider.selectedDay,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null && picked !=
                      eventInfoProvider.selectedDay) {
                      eventInfoProvider.selectDate(picked);
                    }
                  },
                  child: Text(
                    'Selected date: ${DateFormat.yMMMMd().format(eventInfoProvider.selectedDay)}',
                    style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Icon(FontAwesomeIcons.clock),
              Expanded(
                child: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: eventInfoProvider.selectedStartTime,
                    );
                    if (picked != null &&
                        picked != eventInfoProvider.selectedStartTime) {
                      eventInfoProvider.selectStartTime(picked);
                    }
                  },
                  child: Text(
                    'Start time: ${eventInfoProvider.selectedStartTime.format(context)}',
                    style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Icon(FontAwesomeIcons.clock),
              Expanded(
                child: TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: eventInfoProvider.selectedEndTime,
                    );
                    if (picked != null &&
                        picked != eventInfoProvider.selectedEndTime) {
                      eventInfoProvider.selectEndTime(picked);
                    }
                  },
                  child: Text(
                    'End time: ${eventInfoProvider.selectedEndTime.format(context)}',
                    style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                    textAlign: TextAlign.left,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      actions: [
        // Cancels any changes to creating the event
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black)), 
        ),
        TextButton(
          onPressed: () {
            // Error check when the end time is not earlier than the start time
            if (!_isEndTimeAfterStartTime(eventInfoProvider.selectedStartTime,
                eventInfoProvider.selectedEndTime)) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Error',
                  ),
                  content: const Text(
                    'The end time cannot be earlier than the start time!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
              return;
            }
            // Checks for input in the of the event
            if (eventNameController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
                    'Error',
                  ),
                  content: const Text('Please input the name of the event!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
              return;
            }
            final newEvent = Event.newEvent(
              description: eventInfoProvider.name,
              date: eventInfoProvider.selectedDay,
              startTime: eventInfoProvider.selectedStartTime,
              endTime: eventInfoProvider.selectedEndTime,
            );
            eventInfoProvider.name = '';
            eventListProvider.upsertEventEntry(newEvent);
            Navigator.of(context).pop();
          },
          child: const Text('Add', style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  /// Checks if the end time is after the start time
  bool _isEndTimeAfterStartTime(TimeOfDay startTime, TimeOfDay endTime) {
    final start = TimeOfDay(hour: startTime.hour, minute: startTime.minute);
    final end = TimeOfDay(hour: endTime.hour, minute: endTime.minute);
    return end.hour > start.hour ||
        (end.hour == start.hour && end.minute >= start.minute);
  }

  /// Removes an event entry from the event list
  void _removeEvent(BuildContext context, Event event) {
    final eventList = Provider.of<EventListProvider>(context, listen: false);
    eventList.removeEvent(event);
  }

  /// Modifies existing event entry
  void _modifyEvent(
    BuildContext context,
    Event event,
    EventListProvider eventListProvider,
    EventInfoProvider eventInfoProvider,
  ) {
    eventInfoProvider.name = event.description;
    eventInfoProvider.selectedDay = event.date;
    eventInfoProvider.selectedStartTime = event.startTime;
    eventInfoProvider.selectedEndTime = event.endTime;
    showDialog(
      context: context,
      builder: (context) {
        EventInfoProvider eventInfoProviderWithListen =
            Provider.of<EventInfoProvider>(context);
        TextEditingController eventNameController =
            TextEditingController(text: eventInfoProviderWithListen.name);
        ThemeData theme = Theme.of(context);
        return AlertDialog(
          title: const Text('Modify Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (text) {
                  eventInfoProviderWithListen.name = text;
                },
                decoration:
                    const InputDecoration(labelText: 'Event Description'),
                controller: eventNameController,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(FontAwesomeIcons.calendar),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(alignment: Alignment.centerLeft),
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: eventInfoProviderWithListen.selectedDay,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null &&
                            picked != eventInfoProviderWithListen.selectedDay) {
                          eventInfoProviderWithListen.selectDate(picked);
                        }
                      },
                      child: Text(
                        'Selected date: ${DateFormat.yMMMMd().format(eventInfoProviderWithListen.selectedDay)}',
                        style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(FontAwesomeIcons.clock),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(alignment: Alignment.centerLeft),
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime:
                              eventInfoProviderWithListen.selectedStartTime,
                        );
                        if (picked != null &&
                            picked !=
                                eventInfoProviderWithListen.selectedStartTime) {
                          eventInfoProviderWithListen.selectStartTime(picked);
                        }
                      },
                      child: Text(
                        'Start time: ${eventInfoProviderWithListen.selectedStartTime.format(context)}',
                        style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Icon(FontAwesomeIcons.clock),
                  Expanded(
                    child: TextButton(
                      style: const ButtonStyle(alignment: Alignment.centerLeft),
                      onPressed: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime:
                              eventInfoProviderWithListen.selectedEndTime,
                        );
                        if (picked != null &&
                            picked !=
                                eventInfoProviderWithListen.selectedEndTime) {
                          eventInfoProviderWithListen.selectEndTime(picked);
                        }
                      },
                      child: Text(
                        'End time: ${eventInfoProviderWithListen.selectedEndTime.format(context)}',
                        style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                eventInfoProviderWithListen.name = '';
              },
              child:
                  const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                if (!_isEndTimeAfterStartTime(
                    eventInfoProviderWithListen.selectedStartTime,
                    eventInfoProviderWithListen.selectedEndTime)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Error',
                      ),
                      content: const Text(
                          'The end time cannot be earlier than the start time!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                if (eventNameController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        'Error',
                      ),
                      content:
                          const Text('Please input the name of the event!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'OK',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                final newEvent = Event.updated(event,
                    description: eventInfoProviderWithListen.name,
                    date: eventInfoProviderWithListen.selectedDay,
                    startTime: eventInfoProviderWithListen.selectedStartTime,
                    endTime: eventInfoProviderWithListen.selectedEndTime);
                eventInfoProviderWithListen.name = '';
                eventListProvider.upsertEventEntry(newEvent);
                Navigator.of(context).pop();
              },
              child:
                  const Text('Modify', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
