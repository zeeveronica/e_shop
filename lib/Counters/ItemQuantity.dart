import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberofItems = 0;
  int get numberofItem => _numberofItems;
  display(int no) {
    _numberofItems = no;
    notifyListeners();
  }
}
