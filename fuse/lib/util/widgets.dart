import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? lableText;
  final String? errorText;
  final bool enable;
  final bool showtext;
  final int maxLine;
  final int minLine;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ToolbarOptions? toolbarOptions;
  final TextInputAction? textInputAction;
  final Color? textFieldColor;
  final Color? textColor;
  final double? borderRadius;
  final Color? borderColor;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focusBorder;
  final OutlineInputBorder? errorBorder;
  final InputDecoration? decoration;
  final void Function()? onEditingComplete;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  const MyTextField({
    Key? key,
    required this.controller,
    this.hintText,
    this.lableText,
    this.errorText,
    this.maxLine = 1,
    this.minLine = 1,
    this.enable = true,
    this.prefixIcon,
    this.suffixIcon,
    this.toolbarOptions,
    this.textInputAction,
    this.textFieldColor,
    this.textColor,
    this.borderRadius,
    this.borderColor,
    this.border,
    this.focusBorder,
    this.errorBorder,
    this.decoration,
    this.showtext = true,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      style: myTextStyle(color: textColor),
      controller: controller,
      maxLines: (showtext) ? maxLine : 1,
      minLines: minLine,
      textInputAction: textInputAction ?? TextInputAction.next,
      toolbarOptions: toolbarOptions,
      onEditingComplete: onEditingComplete,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      obscureText: !showtext,
      decoration: decoration ??
          InputDecoration(
              enabled: enable,
              filled: true,
              fillColor: textFieldColor,
              border: border ?? myOutlineInputBorder(radius: borderRadius, color: borderColor),
              enabledBorder: border ?? myOutlineInputBorder(radius: borderRadius, color: borderColor),
              focusedBorder: focusBorder ?? myOutlineInputBorder(radius: borderRadius, color: borderColor),
              hintText: hintText,
              labelText: lableText,
              hintStyle: myTextStyle(color: textColor),
              labelStyle: myTextStyle(color: textColor),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              errorBorder: errorBorder ?? myOutlineInputBorder(color: Colors.red, width: 1.5),
              errorText: errorText),
    );
  }

  TextStyle myTextStyle({Color? color, Color? bgColor}) {
    return TextStyle(color: color, backgroundColor: bgColor);
  }

  OutlineInputBorder myOutlineInputBorder({double? radius, Color? color, double? width}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 4)),
      borderSide: (color != null)
          ? BorderSide(
              color: color,
              width: width ?? 1.0,
            )
          : const BorderSide(),
    );
  }
}

class MyButton extends StatelessWidget {
  final Widget child;
  final bool enable;
  final double? elevation;
  final Color? bgColor;
  final Color? fgColor;
  final Color? overLayColor;
  final ButtonStyle? style;
  final Color? shadowColor;
  final BorderSide? borderSide;
  final BorderRadiusGeometry? borderRadius;
  final bool issplashEffect;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  const MyButton({
    Key? key,
    required this.child,
    this.enable = true,
    this.elevation,
    this.bgColor,
    this.fgColor,
    this.overLayColor,
    this.shadowColor,
    this.borderSide,
    this.borderRadius,
    this.issplashEffect = true,
    this.onPressed,
    this.onLongPress,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      style: style ??
          ButtonStyle(
            splashFactory: (issplashEffect) ? InkSplash.splashFactory : NoSplash.splashFactory,
            elevation: (elevation != null) ? MaterialStateProperty.all<double>(elevation!) : null,
            backgroundColor: (bgColor != null) ? MaterialStateProperty.all<Color>(bgColor!) : null, // button bg color
            foregroundColor: (fgColor != null) ? MaterialStateProperty.all<Color>(fgColor!) : null, // text color
            overlayColor: (overLayColor != null) ? MaterialStateProperty.all<Color>(overLayColor!) : null, // hover color
            shadowColor: (shadowColor != null) ? MaterialStateProperty.all<Color>(shadowColor!) : null,
            side: (borderSide != null) ? MaterialStateProperty.all<BorderSide>(borderSide!) : null, // border color
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.zero)),
          ),
      onPressed: (!enable) ? null : onPressed,
      onLongPress: (!enable) ? null : onLongPress,
      child: child,
    );
  }
}

class MyText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextStyle? style;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;

  const MyText(this.text,
      {Key? key,
      this.maxLines,
      this.textAlign,
      this.overflow,
      this.softWrap,
      this.style,
      this.color,
      this.backgroundColor,
      this.fontSize,
      this.fontWeight,
      this.fontStyle,
      this.letterSpacing,
      this.wordSpacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: key,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softWrap,
      style: style ??
          TextStyle(
              color: color,
              backgroundColor: backgroundColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              letterSpacing: letterSpacing,
              wordSpacing: wordSpacing,
              overflow: overflow),
    );
  }
}
