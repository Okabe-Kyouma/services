import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailModel extends ChangeNotifier {
  String? _email;

  String? get email => _email;

  void updateEmail(String myEmail) {
    _email = myEmail;
    notifyListeners();
  }
}
