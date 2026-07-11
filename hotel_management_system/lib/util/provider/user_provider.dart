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
  set usernamePassword(({String usernname, String password}) pair) {
    _username = username;
    _password = password;
  }

// เรียกใช้ ค่าที่ถูก set
  getAge() {
    _bDay;
  }

// ล้างค่า ตัวแปร ทั้งหมด
  clear() {
    _username = "";
    _password = "";
    _bDay = null;
  }
}
