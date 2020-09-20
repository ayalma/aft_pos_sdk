import 'package:aft_pos_sdk/aft_pos_sdk.dart';
import 'package:aft_pos_sdk/src/connection.dart';
import 'package:aft_pos_sdk/src/parsian/parsian_purchase.dart';
import 'package:aft_pos_sdk/src/purchase.dart';
import 'package:aft_pos_sdk/src/saman/saman_purchase.dart';
import 'package:commons/commons.dart';

class PurchaseFactory {
  static Purchase create(PcPosConfig config, Connection connection) {
    ResponseParser parser = ResponseParserFactory.create(config);
    switch (config.pcPosType) {
      case PcPosType.Saman:
        return SamanPurchase(connection, parser);
      case PcPosType.Parsian:
        return ParsianPurchase(connection, parser);
      default:
        throw Exception('Payment type ${config.pcPosType} not supported.');
    }
  }
}
