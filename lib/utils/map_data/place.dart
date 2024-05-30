class Place {
  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.website,
    required this.reviewCount,
    required this.averageRating,
    required this.phone,
    required this.description,
    required this.fulladdress,
  });

  final String name;
  final double latitude;
  final double longitude;
  final String? website;
  final int reviewCount;
  final double averageRating;
  final String? phone;
  final String? description;
  final String fulladdress;


  Place.fromJson(Map<String, dynamic> json) :
    name = json['name'],
    latitude = json['latitude'],
    longitude = json['longitude'],
    website = json['website'],
    reviewCount = json['reviewCount'],
    averageRating = json['averageRating'],
    phone = json['phone'],
    description = json['description'],
    fulladdress = json['fulladdress'];
    
}