import 'dart:typed_data';

import 'package:aft_pos_sdk/src/response_parser.dart';
import 'package:commons/commons.dart';
import 'package:iso8583/iso8583.dart';

class SamanResponseParser extends ResponseParser {
  Message _message;

  SamanResponseParser(PcPosConfig config) : super(config);
  @override
  PurchaseResponse parse(Uint8List response) {
    return PurchaseInitFailed( 1, "", "");
  }
}
