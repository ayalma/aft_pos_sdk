import 'package:dart_des/dart_des.dart';
import 'package:iso8583/iso8583.dart';

class BaseMessage extends Message {
  String get mac => this.dataElements[Fields.F64_MAC];
  void setMac() => this.addFieldValue(
        Fields.F64_MAC,
        genrateMac(
          this.toString(),
          [0x23, 0xAB, 0xE1, 0x82, 0xCA, 0xB5, 0x64, 0x7D],
        ),
      );

  String get processCode => this.dataElements[Fields.F3_ProcessCode];
  set processCode(String value) =>
      this.addFieldValue(Fields.F3_ProcessCode, value);

  String get localTime => this.dataElements[Fields.F12_LocalTime];
  set localTime(String value) =>
      this.addFieldValue(Fields.F12_LocalTime, value);

  String get localDate => this.dataElements[Fields.F13_LocalDate];
  set localDate(String value) =>
      this.addFieldValue(Fields.F13_LocalDate, value);
}

class RAckMessage extends BaseMessage {
  String get responseCode => this.dataElements[Fields.F39_ResponseCode];
  set responseCode(String value) =>
      this.addFieldValue(Fields.F39_ResponseCode, value);
  String get terminalId => this.dataElements[Fields.F41_CA_TerminalID];
  set terminalId(String value) =>
      this.addFieldValue(Fields.F41_CA_TerminalID, value);
}

class SAckMessage extends BaseMessage {
  String get condidateCode => this.dataElements[Fields.F25_POS_ConditionCode];
  set condidateCode(String value) =>
      this.addFieldValue(Fields.F25_POS_ConditionCode, value);

  String get terminalId => this.dataElements[Fields.F41_CA_TerminalID];
  set terminalId(String value) =>
      this.addFieldValue(Fields.F41_CA_TerminalID, value);
}

class NakMessage extends BaseMessage {
  String get condidateCode => this.dataElements[Fields.F25_POS_ConditionCode];
  set condidateCode(String value) =>
      this.addFieldValue(Fields.F25_POS_ConditionCode, value);

  String get terminalId => this.dataElements[Fields.F41_CA_TerminalID];
  set terminalId(String value) =>
      this.addFieldValue(Fields.F41_CA_TerminalID, value);
}

class EOTMessage extends BaseMessage {
  String get responseCode => this.dataElements[Fields.F39_ResponseCode];
  set responseCode(String value) =>
      this.addFieldValue(Fields.F39_ResponseCode, value);
  String get terminalId => this.dataElements[Fields.F41_CA_TerminalID];
  set terminalId(String value) =>
      this.addFieldValue(Fields.F41_CA_TerminalID, value);
}

class DisposeMessage extends BaseMessage {
  String get conditionCode => this.dataElements[Fields.F25_POS_ConditionCode];
  set conditionCode(String value) =>
      this.addFieldValue(Fields.F25_POS_ConditionCode, value);
}

//class CardSwipeMessage {}
extension MacGeneration on Message {
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
