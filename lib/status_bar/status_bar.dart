import 'package:flutter/services.dart';

void setStatusBarStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );
}