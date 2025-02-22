import 'package:server/shared/http/response.dart';
import 'package:server/shared/http/create_request.dart';

TIResponse handleCreateRequest(CreateRequest req) {
  return TIResponse('Create', req.uuid, true);
}