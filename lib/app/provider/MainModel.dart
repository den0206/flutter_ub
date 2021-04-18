import 'package:flutter/material.dart';

class MainPageModel extends ChangeNotifier {
  MainPageModel({
    @required this.sheetHeight,
  });

  final double sheetHeight;
  double mapBottomPadding = 0;

  changePadding() {
    mapBottomPadding = sheetHeight - 30;
    notifyListeners();
  }
}
