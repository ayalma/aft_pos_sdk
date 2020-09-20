import 'dart:typed_data';

import 'package:aft_pos_sdk/src/parsian/pos_response.dart';
import 'package:aft_pos_sdk/src/parsian/tag.dart';
import 'package:aft_pos_sdk/src/response_parser.dart';
import 'package:commons/commons.dart';

class ParsianResponseParser extends ResponseParser {
  ParsianResponseParser(PcPosConfig config) : super(config);

  PosResponse _parseRespanse(String rawRes) {
    int rsCode = -1;

    if (rawRes.length > 4) {
      String lenStr = rawRes.substring(0, 4);
      int length = int.parse(lenStr);

      if (rawRes.length >= length + 4) {
        int lenRS = int.parse(rawRes.substring(6, 9));

        String rs = rawRes.substring(9, 9 + lenRS);

        int numLen = 3;
        int codeTagLen = 2;
        int rsIndex = codeTagLen;
        int rsTagLen = int.parse(rs.substring(rsIndex, rsIndex + numLen));
        rsIndex += numLen;
        int rsCode = int.parse(rs.substring(rsIndex, rsIndex + rsTagLen));
        final response = PosResponse.get(rsCode);
        rsIndex += rsTagLen;
        if (rsCode == PosResponse.c00().getCode) {
          //successful transaction
          while (rsIndex < lenRS) {
            String tag = rs.substring(rsIndex, rsIndex + codeTagLen);
            rsIndex += codeTagLen;
            int tagLen = int.parse(rs.substring(rsIndex, rsIndex + numLen));
            rsIndex += numLen;
            String tagValue = rs.substring(rsIndex, rsIndex + tagLen);
            final tagEnum = Tag.values.firstWhere(
                (element) => element.toString().replaceAll("Tag.", "") == tag,
                orElse: () => null);
            response.vals[tagEnum] = tagValue;
            rsIndex += tagLen;
          }
        }
        return response;
      }
      return PosResponse.get(rsCode);
    }
  }

  @override
  PurchaseResponse parse(Uint8List response) {
    final responseString = String.fromCharCodes(response);
    final parsedResponse = _parseRespanse(responseString);
    switch (parsedResponse.getCode) {
      case 1000:
      case 12:
      case 50:
      case 51:
      case 54:
      case 55:
      case 56:
      case 58:
      case 61:
      case 65:
        return PurchaseFailed(
          
          parsedResponse.getCode,
          parsedResponse.getMessage,
        );
      case 99:
        return PurchaseCanceled();

      case 0:
        return PurchaseSuscces(
          
          "terminalNo",
          parsedResponse.vals[Tag.TR],
          parsedResponse.vals[Tag.RN],
          parsedResponse.vals[Tag.AM],
          parsedResponse.vals[Tag.PN],
          pcPosId: config.id,
          creditTypeId: config.creditCardType.id,
        );

      default:
        return PurchaseInitFailed(
             0, "statusDescription", "errorDescription");
    }
  }
}
