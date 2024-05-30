# Reflection Document

## Identify which of the course topics you applied (e.g. secure data persistence) and describe how you applied them
### Properties of People: Vision

We used this course topic when it came to the design of the map. We made sure to create high contrast touch targets so that it would be easy to use. There are also two different distict colors used in order to differentiate different types of objects.

### Properties of People: Motor Control (e.g. Fitts’s Law)

Once of places we used Fitt's law was when we designed the quick links. We made sure they spanned the screen in order to maximize the size.

### Stateless & stateful widgets

We used stateless and stateful widgets throughout. One of the examples of stateless widges is the expanded view from the map. There isn't any user input that can modify it. An example of a stateful widget is the map view as you can change the visible layers.

### Accessing sensors (force, GPS, etc.)

We access the GPS sensor when it comes to displaying the users current location as well as finding food and activities near them.

### Querying web services

We query web servies when we display the current weather on the homepage. 

### Secure data persistence

We use secure data persistence in our calendar view. We store the events that a user adds in the secure element on app close so they can't be accessed. 

## Describe what changed from your original concept to your final implementation? Why did you make those changes from your original design vision?

We planned to make a friends function for students to connect with their friends, but we found it requires some advanced skills such as backend server programming or serverless implementation. Thus we cancelled that function and implemented the notes function.

Also, we planned to make a todo list together with calendars, but we found that these two are somewhat too similar, so we integrated these two into a function showing events to users.

## Discuss how doing this project challenged and/or deepened your understanding of these topics.

In fact, a majority of our code came from our previous assignment, so we gained a skill of reusing the current code, which led us to a deeper SE perspective.

## Describe two areas of future work for your app, including how you could increase the accessibility and usability of this app

One of the future areas of work for the app could be trying to work with the UW Student service to actullay integrate their API into the app. This would allow students to make changes directly in the app without necessarily having to use the quick links.

Another future area in terms of accesibilty could be making the widgets more dynamic when it comes to user preference. Whether this be adding options to different colors, high contrast, or better large text support, there would all allow the user to get comfortable with the app faster. 

## Cite anything (website or other resource) or anyone that assisted you in creating your solution to this assignment.

- https://stackoverflow.com/questions/78474483/the-plist-file-at-path-doesnt-exist-when-running-app-on-ios
- https://stackoverflow.com/questions/60965610/compass-and-my-location-button-position-on-map-in-flutter
- https://stackoverflow.com/questions/43947552/no-material-widget-found
- https://stackoverflow.com/questions/75257867/how-can-i-show-overlay-on-top-of-the-whole-app-in-flutter
- https://stackoverflow.com/questions/67529930/getting-location-of-iconbutton-tap-event
- https://stackoverflow.com/questions/55465519/how-detect-a-tap-outside-a-widget
- https://stackoverflow.com/questions/61669405/forcing-a-function-to-wait-until-another-function-is-complete
- https://stackoverflow.com/questions/76406169/how-to-load-tile-faster-without-any-blink-while-moving-map-using-flutter-map
- https://github.com/isar/hive/issues/206#issuecomment-582304488
- https://pub.dev/packages/geolocator
- https://github.com/GAM3RG33K/flutter_settings_screens/blob/master/example/lib/cache_provider.dart
- https://github.com/shawnchan2014/haversine-dart
- https://docs.flutter.dev/data-and-backend/serialization/json#creating-model-classes-the-json_serializable-way
- Weather Assignment
- Food Finder Assignment
- Journal Assignement

## What do you feel was the most valuable thing you learned in CSE 340 that will help you beyond this class, and why?

The most valuage thing I learned in CSE 340 was that good design is accessible design and accessible design is good design. Both of those concepts go hand in hand, and making software for accessible is better for everyone. Along with that, accessibility doesn't mean a product has to look bad or sacrifice itself. There is always a balance to be had.

## If you could go back and give yourself 2-3 pieces of advice at the beginning of the class, what would you say and why? (Alternatively: what 2-3 pieces of advice would you give to future students who take CSE 340 and why?

1. Take steps to plan projects before rushing into the code
2. Be ready to read documentation and explore the internet along with the content provided in class
3. Show your apps to your friends and gather feedback throughout development