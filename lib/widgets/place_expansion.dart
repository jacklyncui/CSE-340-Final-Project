import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:hike_uw/utils/map_data/food_data/food_place.dart';
import 'package:hike_uw/utils/map_data/place.dart';
import 'package:hike_uw/utils/url.dart';

class PlaceExpansion extends StatefulWidget {
  final Place place;
  final ColorScheme colorScheme;
  final String widgetType;

  const PlaceExpansion(
      {required this.place, required this.colorScheme, super.key})
      : widgetType = place is FoodPlace ? 'Food' : 'Activity';

  @override
  State<StatefulWidget> createState() => PlaceExpansionState();
}

class PlaceExpansionState extends State<PlaceExpansion> {
  final OverlayPortalController _tooltipController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 50),
      child: OverlayPortal(
        controller: _tooltipController,
        overlayChildBuilder: (BuildContext context) {
          return Center(
            child: openInfoWindow(widget.place, context),
          );
        },
        child: Semantics(
          label: 'Food Place Button',
          child: InkWell(
            onTap: () {
              _tooltipController.show();
            },
            child: Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.colorScheme.primary.withOpacity(0.8),
                border: Border.all(
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget openInfoWindow(Place place, BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              AutoSizeText(
                place.name,
                semanticsLabel: 'Food Place Name',
                minFontSize: 10,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 30),
                maxLines: 2,
              ),
              reviewInformationExpanded(context, widget.widgetType),
              const Spacer(),
              Row(
                children: [
                  formattedButtonRow(context, place),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _tooltipController.hide();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formattedButtonRow(BuildContext context, Place place) {
    return Row(
      children: [
        if (place.website != null)
          formattedButton(
            context,
            'Website',
            'Opens Website',
            Icons.language,
            () => Url.openUrl(place.website!),
          ),
        const SizedBox(
          width: 10,
        ),
        if (place.phone != null)
          formattedButton(
            context,
            'Call',
            'Calls Place',
            Icons.call,
            () => Url.openUrl(
              'tel: ${place.phone!}',
            ),
          ),
      ],
    );
  }

  Widget formattedButton(
    BuildContext context,
    String? text,
    String semanticsLabel,
    IconData icon,
    Function() function,
  ) {
    return PlatformElevatedButton(
      onPressed: function,
      color: Theme.of(context).colorScheme.surfaceDim,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
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

  Widget reviewInformationExpanded(BuildContext context, String type) {
    return Row(
      children: [
        AutoSizeText(
          semanticsLabel: 'Rating: ${widget.place.averageRating} stars',
          minFontSize: 20,
          '${widget.place.averageRating}',
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
          semanticsLabel: '${widget.place.reviewCount} reviews',
          minFontSize: 2,
          '(${widget.place.reviewCount}) ',
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

  Row reviewStars(BuildContext context) {
    List<Icon> stars = [];
    const size = 15.0;
    var color = Theme.of(context).colorScheme.secondary;
    //adds full stars
    for (int i = 0; i < widget.place.averageRating.floor(); i++) {
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
    if (widget.place.averageRating % 1 != 0) {
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
