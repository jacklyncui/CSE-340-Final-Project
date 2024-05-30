import 'package:flutter/material.dart';
import 'package:hike_uw/utils/url.dart';

class QuickLinkWidget extends StatelessWidget {
  final String url;
  final String name;

  const QuickLinkWidget({super.key, required this.url, required this.name});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20),
      ),
      onPressed: () => Url.openUrl(url),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
