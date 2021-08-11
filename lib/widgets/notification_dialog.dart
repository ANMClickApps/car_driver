import 'package:car_driver/constant_text.dart';
import 'package:car_driver/global_variabels.dart';
import 'package:car_driver/helpers/helper_methods.dart';
import 'package:car_driver/model/trip_details.dart';
import 'package:car_driver/screens/new_trip_screen.dart';
import 'package:car_driver/style/brand_color.dart';
import 'package:car_driver/widgets/custom_divider.dart';
import 'package:car_driver/widgets/progress_dialog.dart';
import 'package:car_driver/widgets/taxi_outline_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;

  NotificationDialog({this.tripDetails});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: 30.0),
          Image.asset(
            'assets/images/taxi-min.png',
            width: 100.0,
          ),
          SizedBox(height: 16.0),
          Text(
            textNotificationTitle,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30.0),
          Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/pickicon.png',
                        height: 16.0,
                        width: 16.0,
                        color: BrandColor.colorGreen,
                      ),
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Container(
                          child: Text(tripDetails.pickupAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 18.0)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/desticon.png',
                        height: 16.0,
                        width: 16.0,
                        color: BrandColor.colorPink,
                      ),
                      SizedBox(width: 18.0),
                      Expanded(
                        child: Container(
                          child: Text(
                            tripDetails.destinationAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
          CustomDivider(),
          SizedBox(height: 8.0),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  child: TaxiOutlineButton(
                    title: 'cancel'.toUpperCase(),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                )),
                SizedBox(width: 10.0),
                Expanded(
                    child: Container(
                  child: TaxiOutlineButton(
                    title: 'confirm'.toUpperCase(),
                    color: BrandColor.colorGreen,
                    whiteActive: true,
                    onPressed: () {
                      checkAvailability(context);
                    },
                  ),
                ))
              ],
            ),
          )
        ]),
      ),
    );
  }

  void checkAvailability(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              status: textNotificationAccepting,
            ));

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${userFirebase.uid}/newtrip');
    newRideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);
      Navigator.pop(context);
      String thisRideID = '';

      if (snapshot.value != null) {
        thisRideID = snapshot.value.toString();
      } else {
        Toast.show("Ride not found", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }

      if (thisRideID == tripDetails.rideID) {
        newRideRef.set('accepted');
        HelperMethods.disableHomeTabLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewTripScreen(
                      tripDetails: tripDetails,
                    )));
      } else if (thisRideID == 'cancelled') {
        Toast.show("Ride has been cancelled", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (thisRideID == 'timeout') {
        Toast.show("Ride has been time out", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Ride not found", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}
