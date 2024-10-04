import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationModel extends ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  void updatePosition(Position position) {
    _currentPosition = position;
    notifyListeners();
  }
}
