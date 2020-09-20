import 'package:flutter_test/flutter_test.dart';
import 'package:iso8583/iso8583.dart';

void main() {
  test('test iso message', () {
    print('Available ports:');
    Message test = Message();
    test.mti = MessageTypeIndicator(
      MessageVersion.Iso1987,
      MessageClass.FileActions,
      MessageFunction.Request,
      MessageOrigin.Acquirer,
    );
    test
      ..addFieldValue(Fields.F3_ProcessCode, "000000")
      ..addFieldValue(Fields.F12_LocalTime, "123402")
      ..addFieldValue(Fields.F13_LocalDate, "0303")
      ..addFieldValue(Fields.F25_POS_ConditionCode, "14")
      ..addFieldValue(Fields.F46_AddData_ISO, "300")
      //..addFieldValue(Fields.F47_AddData_National, value)
      ..addFieldValue(Fields.F48_AddData_Private, "")
      ..addFieldValue(Fields.F49_CurrencyCode_Transaction, "364")
      ..addFieldValue(Fields.F56_Reserved_ISO, "")
      ..addFieldValue(Fields.F57_Reserved_National, "1,1,0,0")
      ..addFieldValue(Fields.F64_MAC, "");

    var string = test.toString();
    print(string);
  });
}
