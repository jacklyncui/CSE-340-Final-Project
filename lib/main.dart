import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hike_uw/models/event.dart';
import 'package:hike_uw/models/time_of_day.g.dart';
import 'package:hike_uw/providers/cached_settings_provider.dart';
import 'package:hike_uw/providers/event_info_provider.dart';
import 'package:hike_uw/providers/position_provider.dart';
import 'package:hike_uw/providers/event_list_provider.dart';
import 'package:hike_uw/providers/weather_provider.dart';
import 'package:hike_uw/views/hike_uw.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Register for adapter
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(EventAdapter());

  // The instance for using secure storage
  const secureStorage = FlutterSecureStorage();
  // Try to get the encryption key, in case of the key is null
  final encryptionKeyString = await secureStorage.read(key: 'key');
  // No key stored, generate a new key
  if (encryptionKeyString == null) {
    final key = Hive.generateSecureKey(); // generate a new secure key
    await secureStorage.write(
      // write the key to secure storage
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  // Now the key must not be empty, read again
  final key = await secureStorage.read(key: 'key');

  // Calculate the decoded key
  final decodedkey = base64Url.decode(key!);

  // Open the hive box for events
  final Box<Event> boxForEvents =
      await Hive.openBox('Events', encryptionCipher: HiveAesCipher(decodedkey));

  // Open the hive box for settings
  final Box boxForSettings = await Hive.openBox(
    'Settings',
    encryptionCipher: HiveAesCipher(decodedkey),
  );

  // Wait for the settings to register
  await Settings.init(cacheProvider: CachedSettingsProvider(boxForSettings));

  runApp(
    // Place for providers
    MultiProvider(
      providers: [
        // Provider for Weather
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(),
        ),
        // Provider for Position
        ChangeNotifierProvider<PositionProvider>(
          create: (context) => PositionProvider(),
        ),
        // Provider for Events
        ChangeNotifierProvider<EventListProvider>(
          create: (context) => EventListProvider(boxForEvents),
        ),
        // Provider for Adding event
        ChangeNotifierProvider<EventInfoProvider>(
          create: (context) => EventInfoProvider(),
        ),
      ],
      child: const HikeUW(), // main entry of the app
    ),
  );
}
