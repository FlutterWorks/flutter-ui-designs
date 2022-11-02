import 'package:flutter/material.dart';
import 'package:flutter_uis/configs/AppTheme.dart';
// import 'package:firebase/firebase.dart' as firebase;

import 'package:flutter_uis/configs/Theme.dart' as theme;
import 'package:flutter_uis/configs/AppDimensions.dart';
import 'package:flutter_uis/utils/Utils.dart';

import 'package:flutter_uis/Mixins/HoverWidget.dart';

import '../Dimensions.dart';

class DownloadLink extends StatefulWidget {
  final Map obj;
  DownloadLink(this.obj, {Key? key}) : super(key: key);

  @override
  _DownloadLinkState createState() => _DownloadLinkState();
}

class _DownloadLinkState extends State<DownloadLink> with HoverWidgetMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.buttonWidth,
      // height: 40 + AppDimensions.ratio * 20,
      margin: EdgeInsets.all(AppDimensions.padding * 2),

      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 2, color: theme.primary),
        boxShadow: [
          BoxShadow(
            blurRadius: Utils.rangeMap(this.animation.value, 0.0, 1.0, 4, 8),
            color: theme.primary.withOpacity(
              Utils.rangeMap(this.animation.value, 0.0, 1.0, 0.3, 0.6),
            ),
          )
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: this.buildInkWell(
          onTap: () async {
            Utils.launchUrl(widget.obj["url"]);
          },
          isButton: true,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.padding * 4,
              vertical: AppDimensions.padding * 1.8,
            ),
            child: CustomAnimationBuilder(
              duration: Duration(milliseconds: 280),
              tween: ColorTween(begin: AppTheme.text, end: AppTheme.primary),
              control: this.isFocused
                  ? Control.play : Control.playReverse,
              builder: (context, animation, child) {
                return Row(
                  children: [
                    Icon(
                      widget.obj["icon"],
                      color: animation,
                    ),
                    Container(width: AppDimensions.padding),
                    Text(
                      widget.obj["name"],
                      style: TextStyle(
                        color: animation,
                        fontWeight: FontWeight.w600,
                        fontSize: 8 + AppDimensions.ratio * 3,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
