import 'package:aft_pos_sdk/aft_pos_sdk.dart';
import 'package:aft_pos_sdk/src/parsian/parsian_response_parser.dart';
import 'package:aft_pos_sdk/src/response_parser.dart';
import 'package:aft_pos_sdk/src/saman/saman_response_parser.dart';
import 'package:commons/commons.dart';

class ResponseParserFactory {
  static ResponseParser create(PcPosConfig config) {
    switch (config.pcPosType) {
      case PcPosType.Parsian:
        return ParsianResponseParser(config);
      case PcPosType.Saman:
        return SamanResponseParser(config);
      default:
        throw Exception('PcPosType type ${config.pcPosType} not supported.');
    }
  }
}
