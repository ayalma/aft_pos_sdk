import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'btlv.dart';
import 'pos_response.dart';

class AftPosConnection {
  Socket _connection;
  StreamSubscription _socketSubscription;
  Completer<PosResponse> _responseComplater;
  final String ip;
  final int port;

  AftPosConnection({@required this.ip, @required this.port});

  Future<void> connect() async {
    _connection = await Socket.connect(ip, port);
    _socketSubscription = _connection.listen((data) {
      final dataString = String.fromCharCodes(data);
      _responseComplater?.complete(BTLV.parseRespanse(dataString));
    }, onError: (error) {
      _responseComplater?.completeError(error);
    });
  }

  Future<PosResponse> sendRequest(BTLV btlv) {
    _responseComplater = Completer();
    _connection.write(btlv.toString());
    return _responseComplater.future;
  }

  Future<void> dispose() async {
    _socketSubscription?.cancel();
    _connection.close();
  }
}
