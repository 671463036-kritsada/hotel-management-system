import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _username, _password;
  DateTime? _bDay;

  // getter
  String? get username => _username;
  String? get password => _password;
  DateTime? get b => _bDay;

  // setter ถ้าset แค่ค่าเดียว
  set bday(DateTime d) {
    if (_username == "content") {
      _bDay = d;
    }
  }

  // การทำ setter
  set usernamePassword(({String username, String password}) pair) {
    _username = pair.username;
    _password = pair.password;
    notifyListeners(); 
  }

  getAge() {
    _bDay;
  }

  clear() {
    _username = "";
    _password = "";
    _bDay = null;
    notifyListeners();
  }
}