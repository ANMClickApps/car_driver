import 'package:car_driver/style/brand_color.dart';
import 'package:car_driver/widgets/taxi_outline_button.dart';
import 'package:flutter/material.dart';

class ConfirmSheet extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onPressed;
  ConfirmSheet({this.title, this.subTitle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 15.0,
          spreadRadius: 0.5,
          offset: Offset(
            0.7,
            0.7,
          ),
        )
      ]),
      height: 220.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Text(title.toUpperCase(),
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: BrandColor.colorText)),
            SizedBox(height: 20.0),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColor.colorTextLight),
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'Cancel'.toUpperCase(),
                      color: BrandColor.colorLightGrayFair,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    child: TaxiOutlineButton(
                      title: 'Confirm'.toUpperCase(),
                      color: (title == 'go online')
                          ? BrandColor.colorGreen
                          : Colors.red,
                      whiteActive: true,
                      onPressed: onPressed,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
