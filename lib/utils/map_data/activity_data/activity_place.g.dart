// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityPlace _$ActivityPlaceFromJson(Map<String, dynamic> json) =>
    ActivityPlace(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      website: json['website'] as String?,
      reviewCount: (json['reviewCount'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      fulladdress: json['fulladdress'] as String,
    );

Map<String, dynamic> _$ActivityPlaceToJson(ActivityPlace instance) =>
    <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'website': instance.website,
      'reviewCount': instance.reviewCount,
      'averageRating': instance.averageRating,
      'phone': instance.phone,
      'description': instance.description,
      'fulladdress': instance.fulladdress,
    };
