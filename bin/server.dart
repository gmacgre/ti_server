// General Libs
import "dart:convert";
import 'dart:io';
// Handle Methods
import 'package:server/error.dart';
import 'package:server/login.dart';
// Models
import 'package:server/shared/http/login/login_request.dart';
import 'package:server/shared/http/response.dart';

Set<WebSocket> connections = <WebSocket>{}; 

void handleWebSocket(WebSocket webSocket) {
  connections.add(webSocket); // Add to allow broadcasting. Made later add keying to allow for direct comms for DMs/Chats
  webSocket
    .map((string)=> json.decode(string))
    .listen((json) {
      TIResponse res;
      switch(json['type']) {
        case 'Login':
          res = handleLoginRequest(LoginRequest.fromJson(json));
        case _:
          res = handleErrorRequest(LoginRequest.fromJson(json), 'Request Type not accepted.');
      }
      webSocket.add(jsonEncode(res));
    }, onError: (error) {
      print('Bad WebSocket request');
    })
    .onDone(() {
      print('Removing a Connection');
      connections.remove(webSocket);
      print('New Size: ${connections.length}');
    });
}


void main() {
  int port = 3000;

  HttpServer.bind(InternetAddress.loopbackIPv4, port).then((server) {
    server.transform(WebSocketTransformer()).listen(handleWebSocket);
    print("Search server is running on "
             "'http://${server.address.address}:$port/'");
  });
}

