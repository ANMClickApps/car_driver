import 'package:car_driver/constant_text.dart';
import 'package:car_driver/global_variabels.dart';
import 'package:car_driver/screens/main_screen.dart';
import 'package:car_driver/widgets/taxi_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VehicleInfoScreen extends StatelessWidget {
  static const String id = 'vehicleInfo';

  var carModelController = TextEditingController();
  var carColorController = TextEditingController();
  var vehicleNumberController = TextEditingController();

  void showSnackBar(String title, context) {
    final snackBar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateProfile(context) {
    String id = currentFirebaseUser.user.uid;

    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/$id/vehicle_details');

    Map map = {
      'car_model': carModelController.text,
      'car_color': carColorController.text,
      'vehicle_number': vehicleNumberController.text,
    };

    driverRef.set(map);
    Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Image.asset('assets/images/logo-min.png',
                  height: 110.0, width: 110.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                child: Column(
                  children: [
                    Text(
                      textVehicleScreenTitle,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 25.0),
                    TextField(
                      controller: carModelController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: textVehicleModel,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: carColorController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: textVehicleColor,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      maxLength: 8,
                      controller: vehicleNumberController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: textVehicleNumber,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          )),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 40.0),
                    TaxiButton(
                      text: 'Next',
                      onPressed: () {
                        if (carModelController.text.length < 3) {
                          showSnackBar(textCarModelError, context);
                          return;
                        }
                        if (carColorController.text.length < 3) {
                          showSnackBar(textCarColorError, context);
                          return;
                        }
                        if (vehicleNumberController.text.length < 3) {
                          showSnackBar(textCarNumberError, context);
                          return;
                        }
                        updateProfile(context);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
