import 'package:flutter/material.dart';

import '../../data/model/login_model.dart';

class UserProvider extends ChangeNotifier {

  User? _user;

  User? get user => _user;

  bool get isLogin => _user != null;

  void setUser(User user){
    _user = user;
    notifyListeners();
  }

  void clear(){
    _user = null;
    notifyListeners();
  }

}