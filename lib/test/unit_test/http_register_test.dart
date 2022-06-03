import 'dart:math';

import 'package:blog_app/http/httpUser.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  final HttpUser httpConn =  HttpUser();

  test('register' ,()async{
    var responce =  await httpConn.registerUser('fsaddfsa', 'asfsafds@gmail.com', 'adsffds');
      expect(responce , false);
  });
}
