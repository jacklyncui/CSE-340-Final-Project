import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hike_uw/models/event.dart';

/// The `EventWidget` takes an [Event] object and presents its information,
/// including the event's description and the start and end times, in a styled card.
class EventWidget extends StatelessWidget {
  /// Event to be displayed
  final Event event;

  /// Creates an [EventWidget] with the provided [Event] object
  const EventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.description,
                  style: TextStyle(
                      fontSize: 20, color: theme.colorScheme.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const WidgetSpan(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        const WidgetSpan(
                          child: Icon(FontAwesomeIcons.clock),
                        ),
                        const WidgetSpan(
                          child: SizedBox(
                            width: 10,
                          ),
                        ),
                        TextSpan(
                          text:
                              '${event.startTime.format(context)} - ${event.endTime.format(context)}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
