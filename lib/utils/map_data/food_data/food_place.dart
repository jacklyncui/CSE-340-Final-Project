import 'package:hike_uw/utils/map_data/place.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_place.g.dart';

// See documentation here https://docs.flutter.dev/data-and-backend/serialization/json#creating-model-classes-the-json_serializable-way
// After changing this class, it is essential to run `dart run build_runner build --delete-conflicting-outputs` from the root of the project.

@JsonSerializable()
class FoodPlace extends Place {
  FoodPlace({
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
  @override
  factory FoodPlace.fromJson(Map<String, dynamic> json) =>
      _$FoodPlaceFromJson(json);

  //converts venue to json
  Map<String, dynamic> toJson() => _$FoodPlaceToJson(this);
}
