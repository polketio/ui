import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkawallet_ui/utils/consts.dart';

class PluginTextTag extends StatelessWidget {
  const PluginTextTag(
      {this.margin,
      this.padding,
      this.title = "",
      this.style,
      this.backgroundColor,
      this.child,
      this.height = 25,
      Key? key})
      : super(key: key);
  final String title;
  final TextStyle? style;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: TagBgContainer(
        margin: margin,
        padding: padding,
        height: height,
        backgroundColor: backgroundColor,
        child: child ??
            Text(
              title,
              style: style ??
                  Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.w600, color: Color(0xFF212123)),
            ),
      ),
    );
  }
}

class TagBgContainer extends StatelessWidget {
  const TagBgContainer(
      {this.width,
      this.margin,
      this.padding,
      this.child,
      this.height,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10),
      height: height,
      margin: margin,
      decoration: ShapeDecoration(
        color: backgroundColor ?? PluginColorsDark.headline1,
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10))),
      ),
      child: child,
    );
  }
}
