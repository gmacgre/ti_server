import 'package:server/shared/http/error/error_response.dart';
import 'package:server/shared/http/request.dart';
import 'package:server/shared/http/response.dart';

TIResponse handleErrorRequest(TIRequest request, String message) {
  return ErrorResponse(request.uuid, message);
}