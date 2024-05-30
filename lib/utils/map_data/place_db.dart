import 'dart:convert';

import 'package:hike_uw/utils/map_data/place.dart';
import 'package:hike_uw/utils/haversine.dart';

class PlaceDB {
  final List<Place> _places;

  PlaceDB.initializeFromJson(String jsonString)
      : _places = _decodePlaceListJson(jsonString);

  PlaceDB.intitalizeSuper(List<Place> places) : _places = places;

  static List<Place> _decodePlaceListJson(String jsonString) {
    final listMap = jsonDecode(jsonString);
    final theList = (listMap as List).map((element) {
      return Place.fromJson(element);
    }).toList();
    return theList;
  }

  List<Place> get all {
    return List<Place>.from(_places, growable: false);
  }

  Place findClosestPlace(double latitude, double longitude) {
    double minDistance = double.infinity;
    Place closestPlace = _places[0];

    for (Place place in _places) {
      double distance = Haversine.haversine(
          latitude, longitude, place.latitude, place.longitude);
      if (distance < minDistance) {
        minDistance = distance;
        closestPlace = place;
      }
    }

    return closestPlace;
  }
}
