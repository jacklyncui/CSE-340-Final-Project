import 'package:hike_uw/utils/map_data/place.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_place.g.dart';

// See documentation here https://docs.flutter.dev/data-and-backend/serialization/json#creating-model-classes-the-json_serializable-way
// After changing this class, it is essential to run `dart run build_runner build --delete-conflicting-outputs` from the root of the project.

@JsonSerializable()
class ActivityPlace extends Place {
  ActivityPlace({
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.website,
    required super.reviewCount,
    required super.averageRating,
    required super.phone,
    required super.description,
    required super.fulladdress,
  });

  //creates venue from Json
  factory ActivityPlace.fromJson(Map<String, dynamic> json) =>
      _$ActivityPlaceFromJson(json);

  //converts venue to json
  Map<String, dynamic> toJson() => _$ActivityPlaceToJson(this);
}
