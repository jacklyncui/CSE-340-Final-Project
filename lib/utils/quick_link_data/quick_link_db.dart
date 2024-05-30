import 'dart:convert';

import 'package:hike_uw/utils/quick_link_data/quick_link.dart';

/// This class could be treated as the database for all quick links
class QuickLinkDB {
  /// The list of all QuickLinks
  final List<QuickLink> _quickLinks;

  /// The getter for the [ _quickLinks ]
  List<QuickLink> get all {
    return List<QuickLink>.from(_quickLinks, growable: false);
  }

  /// This is a named constructor to read and decode the json
  QuickLinkDB.initializeFromJson(String jsonString)
      : _quickLinks = _decodeFromQuickListJson(jsonString);

  /// This method helps to decode Json file and put it into the list of QuickLink, [ _quickLinks ]
  static List<QuickLink> _decodeFromQuickListJson(String jsonString) {
    final listMap = jsonDecode(jsonString);
    final theList = (listMap as List).map(
      (element) {
        return QuickLink.fromJson(element);
      },
    ).toList();
    return theList;
  }
}
