import 'package:car_driver/data_provider.dart';
import 'package:car_driver/screens/history_screen.dart';
import 'package:car_driver/style/brand_color.dart';
import 'package:car_driver/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColor.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70.0),
            child: Column(
              children: [
                Text(
                  'Total Earning',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5.0),
                Text('\$${Provider.of<AppData>(context).earnings}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            padding:
                MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryScreen()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 18.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/taxi_car-min.png',
                  width: 70.0,
                ),
                SizedBox(width: 16.0),
                Text(
                  'Trips',
                  style: TextStyle(fontSize: 16.0),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      Provider.of<AppData>(context).tripCount.toString(),
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        CustomDivider(),
      ],
    );
  }
}
