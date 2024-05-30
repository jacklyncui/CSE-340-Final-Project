import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:hike_uw/utils/map_data/activity_data/activity_place_db.dart';
import 'package:hike_uw/utils/map_data/food_data/food_place_db.dart';
import 'package:hike_uw/utils/map_data/place.dart';
import 'package:hike_uw/utils/map_data/place_db.dart';
import 'package:hike_uw/providers/position_provider.dart';
import 'package:hike_uw/widgets/expanded_tile.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

/// Createsa a map view with the user's location, food places, and activity places.
class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _positionStream =
      const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream(
    stream: Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        distanceFilter: 50,
        timeLimit: Duration(minutes: 1),
      ),
    ),
  );

  final _mapController = MapController();

  FoodPlaceDB? _foodPlaces;
  ActivityPlaceDB? _activityPlaces;

  bool _showFoodPlaces = true;
  bool _showActivityPlaces = true;

  @override
  void initState() {
    super.initState();
    loadFoodPlaceDB('assets/food_data.json');
    loadActivityPlaceDB('assets/activity_data.json');
  }

  /// Load the food place database from [dataPath]
  Future<void> loadFoodPlaceDB(String dataPath) async {
    _foodPlaces = FoodPlaceDB.initializeFromJson(
      await rootBundle.loadString(dataPath),
    );
  }

  /// Load the activity place database from [dataPath]
  Future<void> loadActivityPlaceDB(String dataPath) async {
    _activityPlaces = ActivityPlaceDB.initializeFromJson(
      await rootBundle.loadString(dataPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PositionProvider>(
      builder: (
        context,
        positionProvider,
        child,
      ) {
        if (!positionProvider.locationFound ||
            _foodPlaces == null ||
            _activityPlaces == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              positionProvider.latitude,
              positionProvider.longitude,
            ),
            initialZoom: 15.0,
            minZoom: 14.0,
            maxZoom: 19.0,
            cameraConstraint: CameraConstraint.contain(
              bounds: LatLngBounds(
                const LatLng(47.68533558783718, -122.35189955822436),
                const LatLng(47.6372953275523, -122.25886892905021),
              ),
            ),
          ),
          mapController: _mapController,
          children: [
                mapBoxOverlay(),
              ] +
              placeLayers() +
              [
                CurrentLocationLayer(
                  positionStream: _positionStream,
                ),
                mapBoxAttribution(),
                moveButtons(),
                placeLayerSelector(),
              ],
        );
      },
    );
  }

  /// Creates a tile layer with the Google Maps overlay
  Widget mapBoxOverlay() {
    return TileLayer(
      urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
      tileProvider: CancellableNetworkTileProvider(),
    );
  }

  /// Creates a default text style for the map box attribution
  Widget mapBoxAttribution() {
    return const DefaultTextStyle(
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      child: RichAttributionWidget(
        attributions: [
          TextSourceAttribution(
            'Google Maps',
          ),
          TextSourceAttribution(
            'Restaurant Data from Google Maps',
          ),
        ],
      ),
    );
  }

  /// Creates a list of place layers to display on the map
  List<Widget> placeLayers() {
    List<Widget> layers = [];
    if (_showFoodPlaces) {
      layers.add(
        markerWithClusters(
            _foodPlaces!, Theme.of(context).colorScheme.primary, 'Food Place'),
      );
    }
    if (_showActivityPlaces) {
      layers.add(
        markerWithClusters(_activityPlaces!,
            Theme.of(context).colorScheme.tertiary, 'Activity Place'),
      );
    }
    return layers;
  }

  /// Creates a marker cluster layer with the [places] database, [color], and [type]
  /// to identify which type of place
  Widget markerWithClusters(
    PlaceDB places,
    Color color,
    String type,
  ) {
    ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: color,
    );
    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        disableClusteringAtZoom: 18,
        size: const Size(40, 40),
        zoomToBoundsOnClick: false,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50),
        maxZoom: 15,
        markers: places.all
            .map(
              (place) => locationMarker(
                place,
                colorScheme,
                type,
              ),
            )
            .toList(),
        builder: (context, markers) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.secondary),
            child: Center(
              child: Text(
                semanticsLabel:
                    '${markers.length.toString()} $type here, Button',
                markers.length.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Creates a location marker with the [place] and [colorScheme] to identify the type of place
  /// The [type] is used to identify the type of place
  Marker locationMarker(
    Place place,
    ColorScheme colorScheme,
    String type,
  ) {
    return Marker(
        point: LatLng(place.latitude, place.longitude),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExpandedTile(
                    place: place, type: type, colorScheme: colorScheme),
              ),
            );
          },
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(0.8),
              border: Border.all(
                width: 1,
              ),
            ),
          ),
        )
        /*child: PlaceExpansion(
        place: place,
        colorScheme: colorScheme,
      ),*/
        );
  }

  /// Creates a column of move buttons for the user to move to the closest food and activity places
  Widget moveButtons() {
    double latitude =
        Provider.of<PositionProvider>(context, listen: false).latitude;
    double longitude =
        Provider.of<PositionProvider>(context, listen: false).longitude;
    return Align(
      alignment: const Alignment(-0.95, 0.9),
      child: Column(
        children: [
          const Spacer(),
          if (_showFoodPlaces)
            moveButton(
              Icons.restaurant,
              'Move to Closest Food',
              _foodPlaces!.findClosestPlace(latitude, longitude),
              Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(
            height: 10,
          ),
          if (_showActivityPlaces)
            moveButton(
              Icons.directions_run,
              'Move to Closest Activity',
              _activityPlaces!.findClosestPlace(latitude, longitude),
              Theme.of(context).colorScheme.tertiary,
            ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget moveButton(
    IconData icon,
    String tooltip,
    Place place,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: IconButton(
        tooltip: tooltip,
        iconSize: 30,
        color: Colors.white,
        icon: Icon(
          icon,
        ),
        onPressed: () {
          _mapController.moveAndRotate(
            LatLng(
              place.latitude,
              place.longitude,
            ),
            17.0,
            0,
          );
        },
      ),
    );
  }

  /// Places the layer selector button on the map
  Widget placeLayerSelector() {
    GlobalKey actionsKey = GlobalKey();
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 40),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.fromBorderSide(
              BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          child: IconButton(
            key: actionsKey,
            tooltip: 'Layer Selector',
            icon: const Icon(
              Icons.layers,
            ),
            onPressed: () {
              final screenSize = MediaQuery.of(context).size;
              RenderBox renderBox =
                  actionsKey.currentContext!.findRenderObject() as RenderBox;
              Offset offset = renderBox.localToGlobal(Offset.zero);
              layerMenu(
                context,
                left: offset.dx,
                top: offset.dy,
                right: screenSize.width - offset.dx,
                bottom: screenSize.height - offset.dy,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Creates a popup menu to select which layers to display on the map
  void layerMenu(
    BuildContext context, {
    required left,
    required top,
    required right,
    required bottom,
  }) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        left,
        top,
        right,
        bottom,
      ),
      items: [
        PopupMenuItem(
          value: 'food',
          child: Row(
            children: [
              const Text('Food Places'),
              const Spacer(),
              if (_showFoodPlaces) const Icon(Icons.check),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'activity',
          child: Row(
            children: [
              const Text('Activity Places'),
              const Spacer(),
              if (_showActivityPlaces) const Icon(Icons.check),
            ],
          ),
        ),
      ],
    ).then(
      (value) {
        if (value == 'food') {
          setState(() {
            _showFoodPlaces = !_showFoodPlaces;
          });
        } else if (value == 'activity') {
          setState(
            () {
              _showActivityPlaces = !_showActivityPlaces;
            },
          );
        }
      },
    );
  }
}
