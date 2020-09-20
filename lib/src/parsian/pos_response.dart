import 'package:aft_pos_sdk/src/parsian/tag.dart';

///Todo : some refactor is possible
class PosResponse {
  factory PosResponse.c00() => PosResponse(0, "تراکنش موفق");
  factory PosResponse.c12() => PosResponse(12, "تراکنش نامعتبر است");
  factory PosResponse.c50() => PosResponse(50, "عدم برقراری ارتباط با مرکز");
  factory PosResponse.c51() => PosResponse(51, "موجودی کافی نمی باشد");
  factory PosResponse.c54() =>
      PosResponse(54, "تاریخ انقضای کارت سپری شده است");
  factory PosResponse.c55() => PosResponse(55, "رمز کارت اشتباه است");
  factory PosResponse.c56() => PosResponse(56, "کارت نامعت��ر است");
  factory PosResponse.c58() => PosResponse(58, "پایانه غیر مجاز است");
  factory PosResponse.c61() =>
      PosResponse(61, "مبلغ تراکنش بیش از حد مجاز می باشد");
  factory PosResponse.c65() =>
      PosResponse(65, "تعداد دفعات ورود رمز غلط بیش از حد مجاز است");
  factory PosResponse.c99() => PosResponse(99, "لغو درخواست");
  factory PosResponse.c1000() => PosResponse(1000, "ترا��نش  ناموفق");

  int _code;
  String _msg;
  Map<Tag, String> _vals;

  int get getCode => _code;
  String get getMessage => _msg;
   Map<Tag, String> get vals => _vals;

  PosResponse(int code, String message) {
    this._code = code;
    this._msg = message;
    this._vals = Map();
  }

  static PosResponse get(int code) {
    switch (code) {
      case 0:
        return PosResponse.c00();
      case 12:
        return PosResponse.c12();
      case 50:
        return PosResponse.c50();
      case 51:
        return PosResponse.c51();

      case 54:
        return PosResponse.c54();
      case 55:
        return PosResponse.c55();
      case 56:
        return PosResponse.c56();

      case 58:
        return PosResponse.c58();
      case 61:
        return PosResponse.c61();
      case 65:
        return PosResponse.c65();
      case 99:
        return PosResponse.c99();
      case 1000:
        return PosResponse.c1000();

      default:
        return PosResponse.c1000();
    }
  }
}
