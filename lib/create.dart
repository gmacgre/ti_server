import 'package:server/shared/http/create/create_request.dart';
import 'package:server/shared/http/response.dart';

TIResponse handleCreateRequest(CreateRequest req) {
  return TIResponse('Create', req.uuid, true);
}