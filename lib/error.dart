import 'package:server/shared/http/request.dart';
import 'package:server/shared/http/response.dart';

TIResponse handleErrorRequest(TIRequest request, String message) {
  return TIResponse.withMessage(request.type, request.uuid, false, message);
}