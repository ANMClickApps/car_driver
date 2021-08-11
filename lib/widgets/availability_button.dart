import 'package:car_driver/style/brand_color.dart';
import 'package:flutter/material.dart';

class AvailabilityButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;
  const AvailabilityButton(
      {Key key, this.text, this.onPressed, this.color: BrandColor.colorPrimary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(color)),
      child: Container(
        height: 50.0,
        width: 200.0,
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.8),
          ),
        ),
      ),
    );
  }
}
