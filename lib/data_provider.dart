import 'package:car_driver/model/history_model.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String earnings = '0';
  int tripCount = 0;
  List<String> tripHistoryKeys;
  List<HistoryModel> tripHistoryModel = [];

  void updateEarnings(String newEarnings) {
    earnings = newEarnings;
    notifyListeners();
  }

  void updateTripCount(int newTripCount) {
    tripCount = newTripCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateHistoryModel(HistoryModel historyItem) {
    tripHistoryModel.add(historyItem);
    notifyListeners();
  }
}
