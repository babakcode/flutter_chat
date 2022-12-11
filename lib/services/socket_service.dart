import 'dart:async';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/app_constants.dart';

class SocketService {
  final _socketConnection = io.io(
      AppConstants.socketBaseUrl,
      io.OptionBuilder()
          .enableForceNewConnection()
          .disableAutoConnect()
          .setTransports(['websocket']).build());

  final Map<String, Completer<String>> _requests = {};

  Future<String> sendSocketMessage(String data) {
    final completer = Completer<String>();
    final requestId = 'getUniqueId()';

    final request = {
      'id': requestId,
      'data': data,
    };

    _requests[requestId] = completer;

    _socketConnection.send([jsonEncode(request)]);

    return completer.future;
  }

  void _onSocketMessage(String json) {
    final decodedJson = jsonDecode(json);
    final requestId = decodedJson['id'];
    final data = decodedJson['data'];

    if (_requests.containsKey(requestId)) {
      _requests[requestId]?.complete(data);
      _requests.remove(requestId);
    }
  }
}