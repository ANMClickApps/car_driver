import 'dart:async';

import 'package:car_driver/constant_text.dart';
import 'package:car_driver/helpers/helper_methods.dart';
import 'package:car_driver/helpers/pushnotification_service.dart';
import 'package:car_driver/model/driver.dart';
import 'package:car_driver/style/brand_color.dart';
import 'package:car_driver/widgets/availability_button.dart';
import 'package:car_driver/widgets/confirm_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../global_variabels.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();

  User user = FirebaseAuth.instance.currentUser;
  DatabaseReference tripRequestRef;
  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation, distanceFilter: 4);

  String availabilityTitle = 'go online';
  Color availabilityColor = BrandColor.colorPrimary;

  bool isAvalible = false;

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);

    mapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  void getCurrentDriverInfo() async {
    userFirebase = FirebaseAuth.instance.currentUser;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${userFirebase.uid}');
    driverRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        currentDriverInfo = Driver.fromSnapshot(snapshot);
      }
    });
    PushNotificationService pushNotificationService = PushNotificationService();

    // pushNotificationService.initialize(context);
    pushNotificationService.init(context);
    pushNotificationService.getToken();

    HelperMethods.getHistoryInfo(context);
  }

  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(top: 135.0),
          initialCameraPosition: googlePlex,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            mapController = controller;
            getCurrentPosition();
          },
        ),
        Container(
          height: 135.0,
          width: double.infinity,
          color: BrandColor.colorPrimary2,
        ),
        Positioned(
          top: 60.0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AvailabilityButton(
                text: availabilityTitle.toUpperCase(),
                color: availabilityColor,
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ConfirmSheet(
                      title: (!isAvalible) ? 'go online' : 'go offline',
                      subTitle: (!isAvalible)
                          ? textConfirmOnline
                          : textConfirmOffline,
                      onPressed: () {
                        if (!isAvalible) {
                          goOnline();
                          getLocationUpdates();
                          Navigator.pop(context);

                          setState(() {
                            availabilityTitle = 'go offline';
                            availabilityColor = BrandColor.colorGreen;
                            isAvalible = true;
                          });
                        } else {
                          goOffline();
                          Navigator.pop(context);

                          setState(() {
                            availabilityTitle = 'go online';
                            availabilityColor = BrandColor.colorPrimary;
                            isAvalible = false;
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  void goOffline() {
    Geofire.removeLocation(user.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
    tripRequestRef = null;
  }

  void goOnline() async {
    String userUID = user.uid;
    Geofire.initialize('driversAvailable');
    print('USER UID is $userUID');
    Geofire.setLocation(
        userUID, currentPosition.latitude, currentPosition.longitude);

    tripRequestRef =
        FirebaseDatabase.instance.reference().child('drivers/$userUID/newtrip');

    tripRequestRef.set('waiting');
    tripRequestRef.onValue.listen((event) {});
  }

  void getLocationUpdates() {
    homeTabPositionStream = Geolocator.getPositionStream(
            desiredAccuracy: locationOptions.accuracy,
            distanceFilter: locationOptions.distanceFilter)
        .listen((Position position) {
      currentPosition = position;
      if (isAvalible) {
        Geofire.setLocation(user.uid, position.latitude, position.longitude);
      }
      LatLng pos = LatLng(position.latitude, position.longitude);

      mapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
