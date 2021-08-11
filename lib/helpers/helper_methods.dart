import 'dart:math';

import 'package:car_driver/data_provider.dart';
import 'package:car_driver/global_variabels.dart';
import 'package:car_driver/helpers/request_helper.dart';
import 'package:car_driver/model/direction_detail.dart';
import 'package:car_driver/model/history_model.dart';
import 'package:car_driver/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HelperMethods {
  static Future<DirectionDetail> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&mode=driving&key=$mapKeyAndroid';

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetail directionDetails = DirectionDetail();

    directionDetails.durationText =
        response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText =
        response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response['routes'][0]['legs'][0]['distance']['value'];

    directionDetails.encodedPoints =
        response['routes'][0]['overview_polyline']['points'];
    return directionDetails;
  }

  static int estimateFares(DirectionDetail details, int durationValue) {
    //per km = $0.7
    //per minute = $0.5,
    //base fare = $3
    double baseFare = 3;
    double distanceFare = (details.distanceValue / 1000) * 0.3;
    double timeFare = (durationValue / 60) * 0.2;

    double totalFare = baseFare + distanceFare + timeFare;
    return totalFare.truncate();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();
  }

  static void disableHomeTabLocationUpdates() {
    homeTabPositionStream.pause();
    Geofire.removeLocation(userFirebase.uid);
  }

  static void enableHomeTabLocationUpdates() {
    homeTabPositionStream.resume();

    Geofire.setLocation(
        userFirebase.uid, currentPosition.latitude, currentPosition.longitude);
  }

  static void showProgressDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Please wait...',
            ));
  }

  static void getHistoryInfo(context) {
    DatabaseReference earninRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${userFirebase.uid}/earnings');
    earninRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        String earnings = snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    DatabaseReference historyRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${userFirebase.uid}/history');
    historyRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        Map<dynamic, dynamic> value = snapshot.value;
        int tripCount = value.length;
        //update trip count to data provider
        Provider.of<AppData>(context, listen: false).updateTripCount(tripCount);

        List<String> tripHistoryKeys = [];
        value.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        //update trip keys to data provider
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        getHistoryData(context);
      }
    });
  }

  static void getHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for (String key in keys) {
      DatabaseReference historyRef =
          FirebaseDatabase.instance.reference().child('rideRequest/$key');
      historyRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var history = HistoryModel.fromSnapshot(snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateHistoryModel(history);
          print(history.pickup);
        }
      });
    }
  }

  static String formatMyDate(String dateString) {
    DateTime thisDate = DateTime.parse(dateString);
    String formattedDate =
        '${DateFormat.MMMd().format(thisDate)}, ${DateFormat.y().format(thisDate)} - ${DateFormat.jm().format(thisDate)}';
    return formattedDate;
  }
}
