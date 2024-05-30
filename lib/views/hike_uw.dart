import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hike_uw/views/calendar.dart';
import 'package:hike_uw/views/homepage.dart';
import 'package:hike_uw/views/map.dart';
import 'package:hike_uw/views/settings.dart';

class HikeUW extends StatefulWidget {
  const HikeUW({super.key});

  @override
  State<StatefulWidget> createState() => _HikeUWState();
}

class _HikeUWState extends State<HikeUW> {
  // Used to switch between tabs
  int _currentIndex = 0;

  /// Initialization
  @override
  void initState() {
    super.initState();
  }

  /// Remove the object
  @override
  void dispose() {
    super.dispose();
  }

  /// Build the widget for the state
  /// Parameter:
  ///  - [ context ] is the BuildContext helps to build the widget
  /// Returns: MaterialApp(), the whole application
  @override
  Widget build(BuildContext context) {
    // Get the theme's data, we'll use it for colors.
    final ThemeData theme = Theme.of(context);

    return MaterialApp(
      home: PlatformScaffold(
        // The app bar: show the name of the app
        appBar: PlatformAppBar(
          title: const Text(
            'HikeUW',
          ),
          backgroundColor: theme.colorScheme.inversePrimary,
        ),

        // The navigation bar
        bottomNavBar: PlatformNavBar(
          itemChanged: (int index) {
            // Selecting the index
            setState(
              () {
                _currentIndex = index;
              },
            );
          },
          currentIndex: _currentIndex,
          items: const [
            // Application's homepage
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house),
              label: 'Homepage',
            ),
            // Application's map page
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.map),
              label: 'Map',
            ),
            // Application's calendar page
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendar),
              label: 'Calendar',
            ),
            // Application's settings page
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gear),
              label: 'Settings',
            ),
          ],
        ),
        body: DefaultTextStyle(
          style: TextStyle(
              decoration: TextDecoration.none,
              color: theme.colorScheme.onSurface),
          child: SafeArea(
            // Based on different indexes, we go to different destinations
            child: switch (_currentIndex) {
              // homepage
              0 => const HomepageView(),
              // map
              1 => const MapView(),
              // calendar
              2 => const CalendarPage(),
              // settings
              3 => const SettingPage(),
              // fallback, it shouldn't happen, but a placeholder
              _ => const Placeholder(),
            },
          ),
        ),
      ),
    );
  }
}
