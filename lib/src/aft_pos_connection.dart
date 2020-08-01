import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'btlv.dart';
import 'pos_response.dart';
import 'package:rxdart/rxdart.dart';

class AftPosConnection {
  Socket _connection;
  final String ip;
  final int port;

  AftPosConnection({@required this.ip, @required this.port});

  StreamTransformer<Uint8List, String> get _resultTransformer =>
      StreamTransformer.fromHandlers(handleData: (data, bind) {
        final dataString = String.fromCharCodes(data);
        bind.add(BTLV.parseRespanse(dataString));
      });

  Future<void> connect() async {
    _connection = await Socket.connect('192.168.1.241', 1010);
  }

  sendRequest(BTLV btlv) {
    _connection.write(btlv.toString());
  }

  Stream<String> get response => _connection.transform(_resultTransformer);

  Future<void> dispose() async {
    _connection.close();
    //_socketConnection.
  }
}
