import 'package:server/shared/http/login/login_request.dart';
import 'package:server/shared/http/login/login_response.dart';
import 'package:server/shared/model/game.dart';

LoginResponse handleLoginRequest(LoginRequest request, Map<String, Game> keyToGame) {
  if (!keyToGame.containsKey(request.gameId)) {
    return LoginResponse(request.uuid, false)..message = 'Game ID or Password Incorrect';
  }
  Game g = keyToGame[request.gameId]!;
  if(g.password != request.gamePassword) {
    return LoginResponse(request.uuid, false)..message = 'Game ID or Password Incorrect';
  }
  if(g.players.where((player) => player.username == request.userId).isNotEmpty) {
    // Player with given ID already in game
    return LoginResponse(request.uuid, false)..message = 'Player already in game';
  }
  return LoginResponse(request.uuid, true);
}