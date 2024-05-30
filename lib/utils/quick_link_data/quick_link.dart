// Credit: https://pub.dev/packages/json_serializable and the Food Finder app

import 'package:json_annotation/json_annotation.dart';

part 'quick_link.g.dart';

/// This class helps to generate QuickLink
@JsonSerializable()
class QuickLink {
  /// The name of the quicklink
  final String name;

  /// The url of the quicklink
  final String url;

  /// Unnaned Constructor
  QuickLink(this.name, this.url);

  /// Factory constructor that helps to read the links into json
  factory QuickLink.fromJson(Map<String, dynamic> json) =>
      _$QuickLinkFromJson(json);

  /// Put the list into json
  Map<String, dynamic> toJson() => _$QuickLinkToJson(this);
}
