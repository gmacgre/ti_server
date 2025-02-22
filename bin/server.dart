// General Libs
import "dart:convert";
import 'dart:io';
// Handle Methods
import 'package:server/create.dart';
import 'package:server/error.dart';
import 'package:server/login.dart';
import 'package:server/shared/http/create_request.dart';
import 'package:server/shared/http/error_request.dart';
import 'package:server/shared/http/login_request.dart';
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
          CreateRequest req = CreateRequest.fromJson(json);
          res = handleCreateRequest(req);
        case _:
          res = handleErrorRequest(ErrorRequest.fromJson(json), 'Request Type not accepted.');
      }
      print('asdfasdfsadfasdf');
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


void main(List<String> args) async {
  int port = 3000;

  HttpServer? server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  server.transform(WebSocketTransformer()).listen(handleWebSocket);
  print("Search server is running on 'http://${server.address.address}:$port/'");
  if (args.isNotEmpty) {  // If not using the vscode debugger, essentially- running in a console with one arg allows for console input.
    while(true) {
      stdout.write('Enter Command: ');
      String? cmd = stdin.readLineSync();
      switch(cmd) {
        case 'cl':
        case 'close':
          server!.close();
          server = null;
        case 'h':
        case 'help':
          print("cl / close    : Close the server and exit the program\n"
                "g / game [id] : Display the state of one currently loaded game\n"
                "a / games     : Display a list of current games loaded\n"
                "h / help      : Display this list of commands");
        default:
          print(cmd);
      }
      if(server == null) {
        break;
      }
    }
  }
}

