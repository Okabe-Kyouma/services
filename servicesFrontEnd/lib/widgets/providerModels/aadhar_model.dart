import 'package:flutter/material.dart';

class AadharModel extends ChangeNotifier {
  String? _aadhar;

  String? get aadhar => _aadhar;

  void updateAadhar(String myAadhar) {
      _aadhar = myAadhar;
    notifyListeners();
  }
}
