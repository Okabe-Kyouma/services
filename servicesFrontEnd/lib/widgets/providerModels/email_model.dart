import 'package:flutter/material.dart';

class EmailModel extends ChangeNotifier {
  String? _email;

  String? get email => _email;

  void updateEmail(String myEmail) {
    _email = myEmail;
    notifyListeners();
  }
}
