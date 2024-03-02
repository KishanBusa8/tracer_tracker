import 'package:get_storage/get_storage.dart';

class StorageConstants {
  static final storage = GetStorage();

  static const String customBrightness = "customBrightness";
  static const String isDarkMode = "isDarkMode";
  static const String liveTracking = "liveTracking";
  static const String trackerCollection = "tracker";
  static const String locationDoc = "location";
  static const String firebaseMessagingServerKey =
      "AAAAAoNRNxk:APA91bG9OnA66zDMN1Rz4Eun4QY8eX9iQl-Xqgch9G_WcsTu9NtngCf7XF0EAYYFxd5YizwmqESnC28U0b6ILQByyVrRoVql0XAgIlG0qSmcOKrT7Iswe03r3ljpdJF0QPu2XSMiWei_";

  static const List darkMap = [
    {
      "elementType": "geometry",
      "stylers": [
        {"color": "#242f3e"}
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#746855"}
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {"color": "#242f3e"}
      ]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#d59563"}
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#d59563"}
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [
        {"color": "#263c3f"}
      ]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#6b9a76"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {"color": "#38414e"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry.stroke",
      "stylers": [
        {"color": "#212a37"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#9ca5b3"}
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {"color": "#746855"}
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry.stroke",
      "stylers": [
        {"color": "#1f2835"}
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#f3d19c"}
      ]
    },
    {
      "featureType": "transit",
      "elementType": "geometry",
      "stylers": [
        {"color": "#2f3948"}
      ]
    },
    {
      "featureType": "transit.station",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#d59563"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {"color": "#17263c"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [
        {"color": "#515c6d"}
      ]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.stroke",
      "stylers": [
        {"color": "#17263c"}
      ]
    }
  ];
}
