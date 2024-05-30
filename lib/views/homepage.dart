import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hike_uw/providers/event_list_provider.dart';
import 'package:hike_uw/utils/quick_link_data/quick_link_db.dart';
import 'package:hike_uw/utils/weather_checker.dart';
import 'package:hike_uw/widgets/greeting_message.dart';
import 'package:hike_uw/widgets/quick_link_widget.dart';
import 'package:hike_uw/widgets/week_weather_widget.dart';
import 'package:provider/provider.dart';
import 'package:hike_uw/providers/weather_provider.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageState();
}

Future<QuickLinkDB> loadQuickLinkDB(String dataPath) async {
  return QuickLinkDB.initializeFromJson(await rootBundle.loadString(dataPath));
}

class _HomepageState extends State<HomepageView> {
  // Use timer to check current weather at Seattle
  late final Timer _weatherCheckerTimer;
  late final QuickLinkDB _quickLinkDB;

  /// Initialization
  @override
  void initState() {
    final singleUseWeatherProvider = Provider.of<WeatherProvider>(
      context,
      listen: false,
    );
    final WeatherChecker weatherChecker =
        WeatherChecker(singleUseWeatherProvider);

    // Fetch the weather info
    weatherChecker.fetchAndUpdateCurrentSeattleWeather();

    // Set the timer to check the weather
    _weatherCheckerTimer = Timer.periodic(
      const Duration(
        seconds: 60,
      ),
      (timer) => weatherChecker.fetchAndUpdateCurrentSeattleWeather(),
    );

    // Get quick info
    getQuickLinks().then((val) => _quickLinkDB = val);

    super.initState();
  }

  /// Remove the object
  @override
  void dispose() {
    // Need to cancel the timer
    _weatherCheckerTimer.cancel();

    super.dispose();
  }

  /// Build the view for homepage
  /// Parameter:
  ///  - [ context ] is the BuildContext helps to build the widget
  /// Returns: Widget, the whole homepage
  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherProvider, EventListProvider>(
      builder: (context, weatherProvider, eventListProvider, child) {
        return ListView(
          children: [
            ///////////////////////////////////////////////
            // Beginning: Current week, quarter, weather //
            ///////////////////////////////////////////////
            WeekWeatherWidget(weatherProvider: weatherProvider),
            /////////////////////////////////////////
            // End: Current week, quarter, weather //
            /////////////////////////////////////////

            /////////////////////////////////
            // Beginning: Greeting Message //
            /////////////////////////////////
            const GreetingMessage(),
            ///////////////////////////
            // End: Greeting Message //
            ///////////////////////////

            ///////////////////////////
            // Beginning: event list //
            ///////////////////////////
            eventListProvider.build(),
            /////////////////////
            // End: event list //
            /////////////////////

            ////////////////////////////
            // Beginning: Quick links //
            ////////////////////////////
            _buildQuickLinks(),
            //////////////////////
            // End: Quick links //
            //////////////////////
          ],
        );
      },
    );
  }

  Widget _buildQuickLinks() {
    List<Widget> listOfQuickLinks = _quickLinkDB.all.fold(
      [],
      (preVal, curVal) => [
        ...preVal,
        QuickLinkWidget(url: curVal.url, name: curVal.name),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Links: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
          ),
          Wrap(
            spacing: 15,
            runSpacing: 10,
            children: listOfQuickLinks,
          )
        ],
      ),
    );
  }

  Future<QuickLinkDB> getQuickLinks() async {
    return QuickLinkDB.initializeFromJson(
      await rootBundle.loadString(
        'assets/quick_links_data.json',
      ),
    );
  }
}
