# Description
Live Location Tracer and Tracker apps
In this codebase you will find the two different app. One is Tracer and another one is Tracker app.
Tracer app : This app will monitor the live location detection of the Tracker app user.
Tracker app : This app will continuously add it's live location in to the firebase to get realtime updates in Tracer app. even in the background if user kills the app

## Floverwise apps
I have used flutter_flavorizr packager for build two apps with different bundle id in one single code base
You can find the configuration regarding name, bundle id, firebase configuration in falvorizer.yaml file

## For Build app use below commands
*Tracker* -> flutter build apk -t lib/main_tracer.dart  --flavor tracer
*Tracer* -> flutter build apk -t lib/main_tracker.dart  --flavor tracker

## For Run app use below commands
*Tracker* -> flutter run -t lib/main_tracer.dart  --flavor tracer
*Tracer* -> flutter run -t lib/main_tracker.dart  --flavor tracker


## Background location fetch for android
I have used background_location_tracker for fetch background location in realtime even user kills the app.
this plugin is supported in to IOS too but it won't work when user kills the app

## Background location fetch for ios
I have used flutter_background_geolocation for fetch background location in realtime even user kills the app for ios.
This plugin is free for ios but for android license purchase is required that's why I choose this plugin for IOS and this is working on background even if user kills the app.


## State Management
I have used the GetX for state-management because it's light weight and easy to use.






