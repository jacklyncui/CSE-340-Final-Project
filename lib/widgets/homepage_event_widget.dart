import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hike_uw/models/event.dart';
import 'package:intl/intl.dart';

class HomepageEventWidget extends StatelessWidget {
  final Event event;

  const HomepageEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                event.description,
                style:
                    TextStyle(fontSize: 20, color: theme.colorScheme.onSurface),
              ),
            ),
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
                      child: Icon(FontAwesomeIcons.calendar),
                    ),
                    const WidgetSpan(
                      child: SizedBox(
                        width: 10,
                      ),
                    ),
                    TextSpan(
                      text: DateFormat.yMMMMd().format(event.date),
                    ),
                  ],
                ),
              ),
            ),
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
      ),
    );
  }
}
