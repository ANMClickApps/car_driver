import 'package:car_driver/helpers/helper_methods.dart';
import 'package:car_driver/model/history_model.dart';
import 'package:car_driver/style/brand_color.dart';
import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final HistoryModel history;
  HistoryTile({this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/pickicon.png',
                      color: Colors.green,
                      height: 16.0,
                      width: 16.0,
                    ),
                    SizedBox(width: 18.0),
                    Expanded(
                        child: Container(
                      child: Text(
                        history.pickup,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )),
                    SizedBox(width: 5.0),
                    Text(
                      '\$${history.fares}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: BrandColor.colorTextDark,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/desticon.png',
                    color: Colors.red,
                    height: 16.0,
                    width: 16.0,
                  ),
                  SizedBox(width: 18.0),
                  Text(
                    history.destination,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16.0),
                  )
                ],
              ),
              SizedBox(height: 15.0),
              Text(
                HelperMethods.formatMyDate(history.createAt),
                style: TextStyle(color: BrandColor.colorTextLight),
              )
            ],
          )
        ],
      ),
    );
  }
}
