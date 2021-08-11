import 'dart:async';

import 'package:car_driver/model/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

UserCredential currentFirebaseUser;
User userFirebase;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);
String mapKeyAndroid = "YOUR KEY HERE";
String mapKeyIos = "YOUR KEY HERE";

StreamSubscription<Position> homeTabPositionStream;
StreamSubscription<Position> ridePositionStream;

Position currentPosition;
DatabaseReference rideRef;
Driver currentDriverInfo;
