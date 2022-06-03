import 'package:blog_app/http/httpComment.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  final Httpcomment httpConn =  Httpcomment();

  test('Comment' ,()async{
      httpConn.comment('Hello', '12345678');
  });
}