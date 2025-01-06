import "dart:convert";
import 'dart:io';

import 'package:server/login.dart';

Set<WebSocket> connections = <WebSocket>{}; 

void handleWebSocket(WebSocket webSocket) {
  connections.add(webSocket); // Add to allow broadcasting. Made later add keying to allow for direct comms for DMs/Chats
  webSocket
    .map((string)=> json.decode(string))
    .listen((json) {
      switch(json['type']) {
        case 'Login':
          handleLoginRequest(json);
      }
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

