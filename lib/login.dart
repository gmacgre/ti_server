import 'package:server/shared/http/login/login_request.dart';
import 'package:server/shared/http/login/login_response.dart';

LoginResponse handleLoginRequest(LoginRequest request) {
  return LoginResponse(request.uuid, true);
}