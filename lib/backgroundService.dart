//引用來源：https://pub.dev/packages/flutter_background_service/example
//Elius簡化版：https://github.com/Elius0911/FireIOTapp/blob/main/lib/backgroundService.dart

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'json_and_Notification.dart';


Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

//iOS 用
@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

//Android 用
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  //重複執行
  Timer.periodic(Duration(seconds: periodTime), (timer) async {
    if (service is AndroidServiceInstance) {
      jsonDecode_and_alarm(); //偵測&通知
    }
  });
}
