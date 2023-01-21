import 'dart:core';

import 'package:crypt/crypt.dart';


class CryptPassword {
  String hashPassword (String password){
    return Crypt.sha256(password, salt: 'abcdefghijklmnop').toString();
  }
}