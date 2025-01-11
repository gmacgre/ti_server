// General Libs
import "dart:convert";
import 'dart:io';
// Handle Methods
import 'package:server/error.dart';
import 'package:server/login.dart';
// Models
import 'package:server/shared/http/login/login_request.dart';
import 'package:server/shared/http/response.dart';
import 'package:server/shared/model/game.dart';

Map<String, WebSocket> playerToSocket = {};
Map<String, Game> keyToGame = {};
Set<WebSocket> toAdd = {};
// TODO: Make a mySQL Connection here to pass around eventually

void handleWebSocket(WebSocket webSocket) {
  toAdd.add(webSocket);
  webSocket
    .map((string)=> json.decode(string))
    .listen((json) {
      TIResponse res;
      switch(json['type']) {
        case 'Login':
          LoginRequest req = LoginRequest.fromJson(json);
          res = handleLoginRequest(req, keyToGame);
          if (res.isSuccess) {
            toAdd.remove(webSocket);
            playerToSocket['${req.gameId}--${req.userId}'] = webSocket;
          }
        case 'Create':
        case _:
          res = handleErrorRequest(LoginRequest.fromJson(json), 'Request Type not accepted.');
      }
      webSocket.add(jsonEncode(res));
    }, onError: (error) {
      print('Bad WebSocket request');
    })
    .onDone(() {
      print('Removing a Connection');
      // Remove it from the main holdover
      for (String s in playerToSocket.keys) {
        if(playerToSocket[s] == webSocket) {
          print('Removing $s');
          playerToSocket.remove(s);
        }
      }
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

