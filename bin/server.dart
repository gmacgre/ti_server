import 'package:server/login.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;

void main(List<String> arguments) async {
  // Build the server and router

  final server = await shelf_io.serve(logRequests().addHandler(_router), 'localhost', 3000);
  print('Running server on ${server.address.host}:${server.port}');

}

final _router = shelf_router.Router()
  ..get('/', (req) => Response(200))
  ..mount('/api/', shelf_router.Router()
    ..post('/login', loginHandler)
    ..get('/', (req) => Response.ok('Weird to call this but ok'))
  );