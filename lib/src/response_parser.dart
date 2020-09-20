import 'dart:typed_data';

import 'package:commons/commons.dart';

abstract class ResponseParser {
  final PcPosConfig config;

  ResponseParser(this.config);
  PurchaseResponse parse(Uint8List response);
}
