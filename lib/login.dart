import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shared/shared.dart';

Future<Response> loginHandler(Request req) async {
  // For now, just approve the login request if the full stuff is there
  String body = await req.readAsString();
  LoginRequest request;
  try {
    request = LoginRequest.fromJson(jsonDecode(body));
  } on Exception catch (e){
    print(e.toString());
    return Response(400);
  }
  return Response(200, headers: { 
    'Access-Control-Allow-Origin': '*',
  });
}