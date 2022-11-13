import 'dart:async'; //異步處理
import 'dart:convert'; //json 轉換

import 'main.dart';
import 'package:http/http.dart' as http;

//json 解析
Future jsonImport() async {
  var decode; //json 解析後的資料
  int value; //alarm 的值
  String textImport; //匯入的字樣

  //字樣匯入
  final response = await http.get(Uri.parse(url + 'alarm.json'));

  if (response.statusCode == 200) {
    decode = jsonDecode(response.body);
    value = decode['alarm'];
  } else {
    throw Exception('no data ;(');
  }

  if (value == 1) {
    textImport = decode['Text'];
  }
}
