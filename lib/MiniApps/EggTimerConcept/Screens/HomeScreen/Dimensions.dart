import 'package:flutter/material.dart';

import 'package:flutter_uis/configs/AppDimensions.dart';
import 'package:flutter_uis/configs/App.dart';
import 'Theme.dart';

class Dimensions {
  static late double radius;

  static init(BuildContext context) {
    App.init(context);
    ETCTheme.init();

    final maxRadius = 500.0;
    radius = AppDimensions.size.width * 0.75;
    radius = (radius).clamp(-radius, maxRadius);
  }
}
