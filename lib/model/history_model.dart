import 'package:firebase_database/firebase_database.dart';

class HistoryModel {
  String pickup;
  String destination;
  String fares;
  String status;
  String createAt;
  String paymentMethod;

  HistoryModel({
    this.pickup,
    this.destination,
    this.fares,
    this.status,
    this.createAt,
    this.paymentMethod,
  });

  HistoryModel.fromSnapshot(DataSnapshot snapshot) {
    pickup = snapshot.value['pickup_address'];
    destination = snapshot.value['destination_address'];
    fares = snapshot.value['fares'].toString();
    createAt = snapshot.value['create_at'];
    status = snapshot.value['status'];
    paymentMethod = snapshot.value['payment_method'];
  }
}
