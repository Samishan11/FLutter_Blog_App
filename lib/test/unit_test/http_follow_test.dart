import 'package:blog_app/http/httpFollow.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  final Httpfollow httpConn =  Httpfollow();

String? followingid = '123456789098765443';
  test('Follow test' ,()async{
     var res= await httpConn.follow(followingid );
      expect(res , true);
  });
}