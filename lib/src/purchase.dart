import 'package:aft_pos_sdk/aft_pos_sdk.dart';
import 'package:aft_pos_sdk/src/connection.dart';
import 'package:commons/commons.dart';
import 'package:flutter/material.dart';

abstract class Purchase {
  final Connection connection;
  final ResponseParser parser;

  @protected
  Purchase(this.connection, this.parser);

  void setCurrentcy(int currency);
  void setAmount(String amount);
  Future<PurchaseResponse> send();
}
