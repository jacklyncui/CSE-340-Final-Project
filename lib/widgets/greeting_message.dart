import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class GreetingMessage extends StatelessWidget {
  const GreetingMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      child: Text(
        (Settings.getValue('key-name') == '' ||
                Settings.getValue('key-name') == null)
            ? '${greetings()}, Please fill your name in Settings foe better experience!'
            : '${greetings()}, ${Settings.getValue('key-name')}.',
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String greetings() {
    final hour = TimeOfDay.now().hour;

    if (hour <= 4) {
      return 'It is late at night';
    } else if (hour <= 12) {
      return 'Good Morning';
    } else if (hour <= 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }
}
