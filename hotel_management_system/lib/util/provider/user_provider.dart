import 'package:flutter/material.dart';

import '../../data/model/login_model.dart';
class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isLogin => _user != null;

  String? get email => _user?.email;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
    notifyListeners();
  }
}

// class UserProvider extends ChangeNotifier {

//   User? _user;
//   User? _email;
//   User? get user => _user;
//   User? get email => _email;

//   bool get isLogin => _user != null;

//   void setUser(User user){
//     _user = user;
//     notifyListeners();
//   }

//   void clear(){
//     _user = null;
//     notifyListeners();
//   }

// }