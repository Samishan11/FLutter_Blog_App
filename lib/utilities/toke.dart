import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';


Future parseToken()async{
  final storage = new FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  var payload = Jwt.parseJwt(token!);
  return payload;
}