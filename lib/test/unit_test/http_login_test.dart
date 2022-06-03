import 'package:blog_app/http/httpUser.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  final HttpUser httpConn =  HttpUser();
  test('login' ,()async{
    var responce =  await httpConn.loginUser('goku@gmail.com' , 'goku123');
      expect(responce , true);
  });
}