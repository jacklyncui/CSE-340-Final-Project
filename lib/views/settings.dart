import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsInSettings = [
      const SettingsGroup(
        title: 'Customization',
        children: <Widget>[
          TextInputSettingsTile(
            title: 'Your Preferred Name',
            settingKey: 'key-name',
            initialValue: '',
            borderColor: Colors.blueAccent,
            errorColor: Colors.deepOrangeAccent,
          ),
        ],
      ),
    ];

    return ListView.builder(
      itemCount: widgetsInSettings.length,
      itemBuilder: (BuildContext context, int index) {
        return widgetsInSettings[index];
      },
    );
  }
}
