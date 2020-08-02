import 'tag.dart';
import 'pos_response.dart';

class BTLV {
  Map<Tag, String> vals;

  BTLV() {
    this.vals = Map();
    this.vals[Tag.AD] = '';
    this.vals[Tag.PD] = '1';
  }

  void addTagValue(Tag tag, String value) {
    String res = _validate(tag, value.trim());
    if (res == 'true')
      vals[tag] = value.trim();
    else
      throw new Exception(res);
  }

  String _validate(Tag tag, String value) {
    String res = "true";
    switch (tag) {
      case Tag.PR:
        if (value == null || value == '') {
          res = "PR code must NOT be empty";
          break;
        }
        if (!_tryParseInt(value)) {
          res = "PR code must be a valid number";
          break;
        }
        if (value.length != 6) {
          res = "PR code must has 6 digits";
          break;
        }
        break; // that's wrong
      //todo : re run code
      case Tag.AM:
        if (!_tryParseLong(value)) {
          res = "Amount must be a valid number";
          break;
        }
        break;
      case Tag.CU:
        if (!_tryParseInt(value)) {
          res = "Currency code must be a valid number";
          break;
        }
        break;
      case Tag.ST:
        _parseSettelment(value);
        break;
      case Tag.AV:
        _parseKeyValue(value);
        break;
      default:
        break;
    }
    return res;
  }

  bool _tryParseInt(String value) {
    try {
      int.parse(value);
      return true;
    } catch (ex) {
      return false;
    }
  }

  bool _tryParseLong(String value) {
    try {
      int.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool _parseSettelment(String str) {
    final lines = str.split("\r\n");

    lines.forEach((line) {
      final segments = line.split("=");
      if (segments.length != 2) {
        return false;
      }
      return true;
    });

    return true;
  }

  String _extractSettelment(String str) {
    String res = "";
    final lines = str.split("\r\n");
    lines.forEach((line) {
      final segments = line.split("=");
      //we ensure that segments has 2 member; because we test it before by parseSettelment
      String settel = "";
      settel += Tag.AC.toString().replaceAll("Tag.", "") +
          segments[0].trim().length.toString().padLeft(3, '0') +
          segments[0].trim();
      //TODO AM check code abbrev.
      settel += Tag.AM.toString().replaceAll("Tag.", "") +
          segments[1].trim().length.toString().padLeft(3, '0') +
          segments[1].trim();
      res += Tag.ST.toString().replaceAll("Tag.", "") +
          settel.length.toString().padLeft(3, '0') +
          settel;
    });
    return res;
  }

  bool _parseKeyValue(String str) {
    final lines = str.split("\r\n");
    lines.any((line) {
      final keyval = line.split("=");
      if (keyval.length != 2) {
        return false;
      }
    });
    return true;
  }

  String _extractKeyValue(String str) {
    String res = "";
    final lines = str.split("\r\n");
    lines.forEach((line) {
      final keyval = line.split("=");
      //we ensure that segments has 2 member; because we test it before by parseSettelment
      String keyValCode = "";
      keyValCode += Tag.KY.toString().replaceAll("Tag.", "") +
          keyval[0].trim().length.toString().padLeft(3, '0') +
          keyval[0].trim();
      keyValCode += Tag.VL.toString().replaceAll("Tag.", "") +
          keyval[1].trim().length.toString().padLeft(3, '0') +
          keyval[1].trim();
      res += Tag.AV.toString().replaceAll("Tag.", "") +
          keyValCode.length.toString().padLeft(3, '0') +
          keyValCode;
      res += Tag.PV.toString().replaceAll("Tag.", "") +
          keyValCode.length.toString().padLeft(3, '0') +
          keyValCode;
    });

    return res;
  }

  @override
  toString() {
    String cmd = "";
    cmd +=
        '${Tag.PR.toString().replaceAll("Tag.", "")}${vals[Tag.PR].length.toString().padLeft(3, '0')}${vals[Tag.PR]}';
    cmd +=
        '${Tag.AM.toString().replaceAll("Tag.", "")}${vals[Tag.AM].length.toString().padLeft(3, '0')}${vals[Tag.AM]}';
    cmd +=
        '${Tag.CU.toString().replaceAll("Tag.", "")}${vals[Tag.CU].length.toString().padLeft(3, '0')}${vals[Tag.CU]}';
    cmd +=
        '${Tag.R1.toString().replaceAll("Tag.", "")}${vals[Tag.R1].length.toString().padLeft(3, '0')}${vals[Tag.R1]}';
    cmd +=
        '${Tag.R2.toString().replaceAll("Tag.", "")}${vals[Tag.R2].length.toString().padLeft(3, '0')}${vals[Tag.R2]}';
    cmd +=
        '${Tag.T1.toString().replaceAll("Tag.", "")}${vals[Tag.T1].length.toString().padLeft(3, '0')}${vals[Tag.T1]}';
    cmd +=
        '${Tag.T2.toString().replaceAll("Tag.", "")}${vals[Tag.T2].length.toString().padLeft(3, '0')}${vals[Tag.T2]}';
    cmd +=
        '${Tag.SV.toString().replaceAll("Tag.", "")}${vals[Tag.SV].length.toString().padLeft(3, '0')}${vals[Tag.SV]}';
    cmd +=
        '${Tag.SG.toString().replaceAll("Tag.", "")}${vals[Tag.SG].length.toString().padLeft(3, '0')}${vals[Tag.SG]}';
    cmd +=
        '${Tag.AD.toString().replaceAll("Tag.", "")}${vals[Tag.AD].length.toString().padLeft(3, '0')}${vals[Tag.AD]}';
    cmd +=
        '${Tag.PD.toString().replaceAll("Tag.", "")}${vals[Tag.PD].length.toString().padLeft(3, '0')}${vals[Tag.PD]}';
    if (vals.containsKey(Tag.ST)) cmd += _extractSettelment(vals[Tag.ST]);
    if (vals.containsKey(Tag.AV)) cmd += _extractKeyValue(vals[Tag.AV]);
    int lenght = cmd.length;
    String finalMsg = "RQ" + lenght.toString().padLeft(3, '0') + cmd;
    return '${finalMsg.length.toString().padLeft(4, "0")}$finalMsg';
  }

  static PosResponse parseRespanse(String rawRes) {
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

        rsIndex += rsTagLen;
        if (rsCode == PosResponse.c00().getCode) {
          //successful transaction
          while (rsIndex < lenRS) {
            String tag = rs.substring(rsIndex, rsIndex + codeTagLen);
            rsIndex += codeTagLen;
            int tagLen = int.parse(rs.substring(rsIndex, rsIndex + numLen));
            rsIndex += numLen;
            String tagValue = rs.substring(rsIndex, rsIndex + tagLen);

            rsIndex += tagLen;
          }
        }
      }
    }

    return PosResponse.get(rsCode);
  }
}
