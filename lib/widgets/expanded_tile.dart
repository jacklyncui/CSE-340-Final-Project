import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hike_uw/utils/map_data/place.dart';
import 'package:hike_uw/utils/url.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_launcher/maps_launcher.dart';

/// creates an expanded tile view for more details on a place
/// Parameters:
///  - place: place to get data from
class ExpandedTile extends StatelessWidget {
  final Place place;
  final String type;
  final ColorScheme colorScheme;

  const ExpandedTile(
      {required this.place,
      required this.type,
      required this.colorScheme,
      super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: () {
            if (MediaQuery.of(context).size.aspectRatio < 0.7) {
              return portraitView(context);
            }
            return landscapeView(context);
          }(),
        ),
      ),
    );
  }

  /// Builds portrait for Expanded Tile View using [context]
  Widget portraitView(BuildContext context) {
    return Column(
      children: [
        cardWithplaceData(context),
        const SizedBox(height: 5),
        Expanded(child: cardWithMapData(context)),
        const SizedBox(height: 5),
        formattedButtonRow(context),
        const SizedBox(height: 10),
      ],
    );
  }

  /// Builds landscape for Expanded Tile View using [context]
  Widget landscapeView(BuildContext context) {
    return Column(
      children: [
        cardWithplaceData(context),
        Expanded(
          child: Row(
            children: [
              Expanded(child: cardWithMapData(context)),
              formattedButtonColumn(context)
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// Builds a Card with place data for Expanded Tile View
  Widget cardWithplaceData(
    BuildContext context,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AutoSizeText(
                semanticsLabel: 'place: ${place.name}',
                place.name,
                minFontSize: 15,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w400,
                  fontSize: 35,
                ),
              ),
            ),
            const SizedBox(height: 5),
            reviewInformationExpanded(context, type),
            const SizedBox(height: 5),
            if (place.description != null)
              AutoSizeText(
                semanticsLabel: 'Description: ${place.description}',
                place.description ?? '',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a Card with map data for Expanded Tile View using [context]
  Widget cardWithMapData(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Semantics(
            label: 'Map View, Button',
            child: FlutterMap(
              options: MapOptions(
                  initialCenter: LatLng(
                    place.latitude,
                    place.longitude,
                  ),
                  initialZoom: 15,
                  maxZoom: 19,
                  minZoom: 13,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.pinchZoom,
                  ),
                  onTap: (a, b) =>
                      MapsLauncher.launchQuery(place.fulladdress).ignore()),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                        point: LatLng(place.latitude, place.longitude),
                        width: 20,
                        height: 20,
                        alignment: Alignment.topCenter,
                        child: const Icon(Icons.location_on))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a Row with review information for Expanded Tile View using [context]
  /// and [type] of place
  Widget reviewInformationExpanded(BuildContext context, String type) {
    return Row(
      children: [
        AutoSizeText(
          semanticsLabel: 'Rating: ${place.averageRating} stars',
          minFontSize: 20,
          '${place.averageRating}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        reviewStars(context),
        const SizedBox(
          width: 10,
        ),
        AutoSizeText(
          semanticsLabel: '${place.reviewCount} reviews',
          minFontSize: 2,
          '(${place.reviewCount}) ',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 13),
        ),
        const Spacer(),
        AutoSizeText(
          semanticsLabel: type,
          type,
          maxLines: 2,
          minFontSize: 10,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }

  /// Builds a Row with buttons for Expanded Tile View using [context]
  Widget formattedButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (place.website != null)
          formattedButton(
            context,
            'Website',
            'Opens Website',
            Icons.language,
            () => Url.openUrl(place.website ?? ''),
          ),
        if (place.phone != null)
          formattedButton(
            context,
            'Call',
            'Calls place',
            Icons.call,
            () => Url.openUrl(
              'tel: ${place.phone ?? ''}',
            ),
          ),
      ],
    );
  }

  /// Builds a Column with buttons for Expanded Tile View using [context]
  Widget formattedButtonColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (place.website != null)
          formattedButtonNoText(
            context,
            'Opens Website',
            Icons.language,
            () => Url.openUrl(place.website ?? ''),
          ),
        if (place.phone != null)
          formattedButtonNoText(
            context,
            'Calls Venue',
            Icons.call,
            () => Url.openUrl(
              'tel: ${place.phone ?? ''}',
            ),
          ),
      ],
    );
  }

  /// Builds a formatted button for Expanded Tile View using [context]
  /// and [text], [semanticsLabel], [icon], [function]
  Widget formattedButton(
    BuildContext context,
    String? text,
    String semanticsLabel,
    IconData icon,
    Function() function,
  ) {
    return PlatformElevatedButton(
      onPressed: function,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
      color: colorScheme.primary.withOpacity(0.5),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
          if (text != null)
            const SizedBox(
              width: 7,
            ),
          if (text != null)
            AutoSizeText(
              semanticsLabel: semanticsLabel,
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a formatted button without text for Expanded Tile View using [context]
  /// and [semanticsLabel], [icon], [function]
  Widget formattedButtonNoText(
    BuildContext context,
    String semanticsLabel,
    IconData icon,
    Function() function,
  ) {
    return SizedBox(
      width: 37,
      height: 37,
      child: PlatformElevatedButton(
        onPressed: function,
        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        color: colorScheme.primary.withOpacity(0.5),
        child: Semantics(
          label: semanticsLabel,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
      ),
    );
  }

  /// Builds a Row with stars for Expanded Tile View using [context]
  Row reviewStars(BuildContext context) {
    List<Icon> stars = [];
    const size = 15.0;
    var color = Theme.of(context).colorScheme.secondary;
    //adds full stars
    for (int i = 0; i < place.averageRating.floor(); i++) {
      stars.add(
        Icon(
          Icons.star,
          fill: 1.0,
          size: size,
          color: color,
        ),
      );
    }
    //adds half star if rating isn't even
    if (place.averageRating % 1 != 0) {
      stars.add(
        Icon(
          Icons.star_half,
          size: size,
          color: color,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stars,
    );
  }
}
