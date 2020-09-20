import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

//import 'package:dart_serial_port/dart_serial_port.dart';

abstract class Connection {
  Future<void> connect();
  Future<Uint8List> write(Object data);
  Future<void> dispose();
}

// class SerialConnection extends Connection {
//   SerialPort _serialPort;
//   final String portName;
//   Completer<Uint8List> _responseComplater;

//   SerialConnection({this.portName});
//   @override
//   Future<void> connect() {
//     _serialPort = SerialPort(this.portName);
//     var result = _serialPort.openReadWrite();
//     _serialPort.drain();
//     return Future.value();
//   }

//   @override
//   Future<void> dispose() {
//     _serialPort?.dispose();
//     return Future.value();
//   }

//   @override
//   Future<Uint8List> write(Object data) {
//     _responseComplater = Completer();

//     int result = _serialPort.write(data);
//     return _responseComplater.future;
//   }
// }

class NetworkConnection extends Connection {
  Socket _connection;
  StreamSubscription _socketSubscription;
  Completer<Uint8List> _responseComplater;
  final String ip;
  final int port;

  NetworkConnection({this.ip, this.port});

  @override
  Future<Uint8List> write(Object data) {
    _responseComplater = Completer();

    _connection?.write(data);
    return _responseComplater.future;
  }

  @override
  Future<void> connect() async {
    _connection =
        await Socket.connect(ip, port, timeout: Duration(milliseconds: 1000));

    _socketSubscription = _connection?.listen((data) {
      _responseComplater?.complete(data);
    }, onError: (error) {
      _responseComplater?.completeError(error);
    });
  }

  @override
  Future<void> dispose() async {
    _socketSubscription?.cancel();
    _connection?.close();
  }
}
