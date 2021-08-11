import 'package:car_driver/helpers/helper_methods.dart';
import 'package:car_driver/widgets/custom_divider.dart';
import 'package:car_driver/widgets/taxi_button.dart';
import 'package:flutter/material.dart';

class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final int fares;

  CollectPayment({
    this.paymentMethod,
    this.fares,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.0),
            Text('$paymentMethod payment'.toUpperCase()),
            SizedBox(height: 20.0),
            CustomDivider(),
            SizedBox(height: 16.0),
            Text(
              '\$$fares',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50.0),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Amount abobe is the total fares to be charged to the rider',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              width: 230.0,
              child: TaxiButton(
                text: (paymentMethod == 'cash') ? 'Collect cash' : 'confirm',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  HelperMethods.enableHomeTabLocationUpdates();
                },
              ),
            ),
            SizedBox(height: 40.0)
          ],
        ),
      ),
    );
  }
}
