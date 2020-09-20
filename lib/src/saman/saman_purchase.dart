// import 'package:aft_pos_sdk/src/request_builder.dart';
// import 'package:iso8583/iso8583.dart';
import 'dart:io';

import 'package:aft_pos_sdk/src/connection.dart';
import 'package:aft_pos_sdk/src/purchase.dart';
import 'package:aft_pos_sdk/src/response_parser.dart';
import 'package:commons/commons.dart';
import 'package:dart_des/dart_des.dart';
import 'package:convert/convert.dart' as h;

import 'package:iso8583/iso8583.dart';

class SamanPurchase extends Purchase {
  var _key = [0x23, 0xAB, 0xE1, 0x82, 0xCA, 0xB5, 0x64, 0x7D];
  Message _message;

  SamanPurchase(Connection connection, ResponseParser parser)
      : super(connection, parser) {
    var time = DateTime.now();

    _message = Message()
      ..mti = MessageTypeIndicator(
        MessageVersion.Iso1987,
        MessageClass.FileActions,
        MessageFunction.Request,
        MessageOrigin.Acquirer,
      )
      ..addFieldValue(Fields.F3_ProcessCode, "000000")
      ..addFieldValue(Fields.F4_AmountTransaction, "1000")
      ..addFieldValue(Fields.F12_LocalTime,
          "${time.hour.toString().padLeft(2, '0')}${time.minute.toString().padLeft(2, '0')}${time.second.toString().padLeft(2, '0')}")
      ..addFieldValue(Fields.F13_LocalDate,
          "${time.month.toString().padLeft(2, '0')}${time.day.toString().padLeft(2, '0')}")
      ..addFieldValue(Fields.F25_POS_ConditionCode, "14")
      ..addFieldValue(Fields.F46_AddData_ISO, "300")
      //..addFieldValue(Fields.F47_AddData_National, "1")
      // ..addFieldValue(Fields.F48_AddData_Private, "200003123001a11003456001c")
      ..addFieldValue(Fields.F49_CurrencyCode_Transaction, "364")
      //..addFieldValue(Fields.F56_Reserved_ISO, "1")
      ..addFieldValue(
          Fields.F57_Reserved_National, h.hex.encode("1.0.4.9".codeUnits));
    // ..addFieldValue(Fields.F63_Reserved_Private, "14785");
    _message.addFieldValue(
        Fields.F64_MAC,
        genrateMac(_message.toString(),
            [0x23, 0xAB, 0xE1, 0x82, 0xCA, 0xB5, 0x64, 0x7D]));
  }

  @override
  Future<PurchaseResponse> send() async {
    try {
      await connection.connect();
      var message = _message.toString();
      var resultData = await connection.write(message);
      var parsedData = parser.parse(resultData);
      await connection.dispose();
      return parsedData;
    } catch (e) {
      await connection.dispose();
      throw e;
    }
  }

  @override
  void setAmount(String amount) {}

  @override
  void setCurrentcy(int currency) {}

  genrateMac(String message, List<int> key) {
    var list = Iterable<int>.generate(message.length);
    var hex = list.where((x) => x % 2 == 0).map((x) {
      return int.parse(
          message.substring(x, (x + 2) < list.length ? (x + 2) : list.length),
          radix: 16);
    }).toList();

    DES desECB = DES(key: key, mode: DESMode.CBC);
    var encrypted = desECB.encrypt(_pad(hex));

    int start = ((encrypted.length / 8 - 1) * 8).toInt();

    var buffer = encrypted.sublist(start, start + 8);
    var mac = "";
    for (var i = 0; i <= 7; i++) {
      mac += buffer[i].toRadixString(16).toUpperCase();
    }
    return mac;
  }

  List<int> _pad(List<int> data) {
    final padding = List.generate(8, (index) => 0);
    int size = padding.length;
    int left = size - (data.length % size);
    return data + padding.sublist(0, left);
  }
}
