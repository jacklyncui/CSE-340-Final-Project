# CSE-340-Final-Project (a.k.a HikeUW)

![Static Badge](https://img.shields.io/badge/Course_Number-CSE_340-yellow) ![Static Badge](https://img.shields.io/badge/Group_Number-14-brightgreen) ![Static Badge](https://img.shields.io/badge/Group_Members-4-brightgreen)  ![GitHub License](https://img.shields.io/github/license/jacklyncui/CSE-340-Final-Project) ![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/jacklyncui/CSE-340-Final-Project)

HikeUW is an application built with Flutter. It aims to make lives easier at the University of Washington with many integrated features, including planning your schedule and finding resources around campus.

## Installation


### Installation on macOS and iOS

Before installing the app on your device, you need to make sure you have turned on the developer mode on your device because you need to build the app on your own.

**You will need to use your own developer account to build the application.**

#### macOS

If you are trying to run the app on macOS, just clone this repo and build the application:
```bash
git clone git@github.com:jacklyncui/CSE-340-Final-Project.git
open macos/Runner.xcworkspace
```

#### iOS

If you are trying to run the app on iOS, just clone this repo and build the application:
```bash
git clone git@github.com:jacklyncui/CSE-340-Final-Project.git
open ios/Runner.xcworkspace
```

### Installation on Android

**We STRONGLY recommend you not using Android to run this version of this app, since the developers has only tested the app on macOS and iOS. There may be some unexpected behaviors of the application.**

You need to build the Android `.apk` file on your own and install on your device after cloning the repo:
```bash
git clone git@github.com:jacklyncui/CSE-340-Final-Project.git
flutter build apk --release
```

Then you can find the built file under `build/app/outputs/flutter-apk/app-release.apk`. You can install it on your device.

## Usage

When using this app, you need to enable the permission for location and Internet access.

## Contributing

Unfortunately, this project would not have long-term maintenance. If you wish to contribute to this project, please clone it and modify the code, as long as your usage does not violate `LICENSE`.

## Authors and acknowledgment
This project is created by Group 14. For the sake of privacy, please contact me (jacklync [at] acm.org) for more information,

We thank course staff members from CSE 340 who gave the starter code in the Weather assignment, as well as the support from them. We would also like to thank Google for their search results on some issues we encountered in development, as well as StackOverflow, Flutter Official documentation, and GitHub, for some of the solutions to the issues we encountered in development.

## License

All assets and code are under the [MIT LICENSE](LICENSE) unless specified otherwise.

## Project status

![Static Badge](https://img.shields.io/badge/Project_Status-Finished-brightgreen)

The project has finished the development right now.

## Data Design and Data Flow

There are following folders under the `lib` folder:
- `enums` is the folder for storing enums we used. Specifically, `weather_condition.dart` is from Weather assignment.
- `models` is the folder for data structure of different objects. Specifically:
  - `event_list.dart` is the whole list of events
  - `event.dart` is the model for a single event
  - The other two files, `event.g.dart` and `time_of_day.g.dart` are for Hive to use (storing the user's data).
- `providers` is the folder for different providers
  - `cached_settings_provider.dart` is the provider for settings, it is **not** inherited from `ChangeNotifier`. It is inheriented from `CacheProvider`, which comes from a package named `flutter_settings_screens`.
  - `event_info_provider.dart` is the provider for making a single event
  - `event_list_provider.dart` is the provider for a list of all events
  - `position_provider.dart` is the provider for position information (from Food Finder assignment)
  - `weather_provider.dart` is the provider for weather information (from Weather assignment)
- `utils` is the folder for the utilities we used in this assignment. Specifically,
  - Folder `map_data` contains the utilities for map
  - Folder `quick_link_data` contains the utilities for quick links
  - `date_info.dart` contains the information for the current date
  - `haversine.dart` containbs the function for combining different places
  - `url.dart` is for opening a URL.
  - `weather_checker.dart` is for checking the weather at Seattle, which is from the Weather assignment.
- `views` is the folder for different views, it contains a calendar view, the homepage view, the map view, the settings view, and `hike_uw.dart` for the app bar.
- `widgets` is the folder for different widgets, such as `event_widget.dart`, `quick_link_widget.dart`, `week_weather_widget.dart`, `expanded_tile.dart`.

Also, our comments and reflections were under `docs` folder.
