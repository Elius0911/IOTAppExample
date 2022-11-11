import 'dart:async'; //異步處理
import 'dart:convert'; //json 轉換

import 'package:http/http.dart' as http;

import 'main.dart';
import 'NotificationService.dart';
import 'backgroundService.dart';

int periodTime = 2; //TODO: 週期時間
bool firstTime = true;
String warningText = ""; //警告字樣(更新後)

//json 解析 & 警報
Future jsonDecode_and_alarm() async {
  var decode; //json 解析後的資料
  int value; //是否起火或有煙霧
  String warningText_first; //第一次警告字樣
  String warningTextImport; //警告字樣匯入

  //第一次警告字樣匯入
  if (firstTime == true) {
    final response = await http.get(Uri.parse(url + 'alarm.json'));

    if (response.statusCode == 200) {
      decode = jsonDecode(response.body);
      value = decode['alarm'];
    } else {
      throw Exception('no data ;(');
    }

    if (value == 1) {
      warningText_first = decode['warningText'];
      //通知(ID, 標題, 內容)
      NotificationService().showNotification(1, "居家防災警報", warningText_first);
      firstTime = false;
      warningText = warningText_first;
    }
  } else {
    final response = await http.get(Uri.parse(url + 'alarm.json'));

    if (response.statusCode == 200) {
      decode = jsonDecode(response.body);
      value = decode['alarm'];
    } else {
      throw Exception('no data ;(');
    }
    if (value == 1) {
      warningTextImport = decode['warningText'];

      //若警告字樣不重複 則發出通知
      if (warningTextImport != warningText) {
        warningText = warningTextImport;
        NotificationService().showNotification(1, "居家防災警報", warningText);
      }
    }
  }
}
