import 'dart:io';

import 'package:car_driver/constant_text.dart';
import 'package:car_driver/global_variabels.dart';
import 'package:car_driver/model/trip_details.dart';
import 'package:car_driver/widgets/notification_dialog.dart';
import 'package:car_driver/widgets/progress_dialog.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PushNotificationService {
  bool _initialized = false;
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context) async {
    if (!_initialized) {
      await fcm.requestPermission();
      fcm
          .getInitialMessage()
          .then((message) => fetchRideInfo(getRideId(message.data), context));
      FirebaseMessaging.onMessage
          .listen((message) => fetchRideInfo(getRideId(message.data), context));
      FirebaseMessaging.onMessageOpenedApp
          .listen((message) => fetchRideInfo(getRideId(message.data), context));
      _initialized = true;
    }
  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${userFirebase.uid}/token');
    tokenRef.set(token);

    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }

  String getRideId(Map<String, dynamic> message) {
    print('MESSAGE IS: $message');
    String rideId = '';

    if (Platform.isAndroid) {
      rideId = message['ride_id'];
      print('IF first ride_id: $rideId');
    } else {
      rideId = message['ride_id'];
      print('ride_id: $rideId');
    }
    return rideId;
  }

  void fetchRideInfo(String rideId, context) {
    print('RIDEID is: $rideId');
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: textNotificationGetDetails,
            ));

    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest/$rideId');
    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);

      if (snapshot.value != null) {
        // final assetsAudioPlayer = AssetsAudioPlayer();
        // assetsAudioPlayer.open(Audio('assets/sounds/alert.mp3'));
        // assetsAudioPlayer.play();

        double pickupLat =
            double.parse(snapshot.value['location']['latitude'].toString());
        double pickupLng =
            double.parse(snapshot.value['location']['longitude'].toString());
        String pickupAddress = snapshot.value['pickup_address'].toString();

        double destinationLat =
            double.parse(snapshot.value['destination']['latitude'].toString());
        double destinationLng =
            double.parse(snapshot.value['destination']['longitude'].toString());

        String destinationAddress = snapshot.value['destination_address'];
        String paymentMethod = snapshot.value['payment_method'];
        String riderName = snapshot.value['rider_name'];
        String riderPhone = snapshot.value['rider_phone'];

        TripDetails tripDetails = TripDetails();
        tripDetails.rideID = rideId;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.riderName = riderName;
        tripDetails.riderPhone = riderPhone;

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) =>
                NotificationDialog(tripDetails: tripDetails));
      }
    });
  }
}
