import 'package:car_driver/style/brand_color.dart';
import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final Function onPressed;
  const TaxiButton({
    Key key,
    this.text,
    this.onPressed,
    this.backgroundColor: BrandColor.colorPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
      onPressed: onPressed,
      child: Container(
        height: 50.0,
        child: Center(
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5),
          ),
        ),
      ),
    );
  }
}
