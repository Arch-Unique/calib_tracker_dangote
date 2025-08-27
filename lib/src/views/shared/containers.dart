import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calib_tracker_dangote/src/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CurvedContainer extends StatefulWidget {
  final Widget? child;
  final double radius;
  final double? width, height;
  final String? image;
  final Color color;
  final Border? border;
  final BorderRadius? brad;
  final bool shouldClip;
  final List<BoxShadow> boxshadow;
  final VoidCallback? onPressed;
  final EdgeInsets? margin, padding;
  const CurvedContainer(
      {this.child,
      this.radius = 8,
      this.height,
      this.width,
      this.onPressed,
      this.margin,
      this.brad,
      this.padding,
      this.border,
      this.boxshadow = const [],
      this.image,
      this.shouldClip = true,
      this.color = Colors.white,
      super.key});

  @override
  State<CurvedContainer> createState() => _CurvedContainerState();
}

class _CurvedContainerState extends State<CurvedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
    _animationController.reverse();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onPressed == null
          ? MouseCursor.defer
          : SystemMouseCursors.click,
      onHover: widget.onPressed == null
          ? null
          : (_) {
              _animationController.forward();
            },
      onExit: widget.onPressed == null
          ? null
          : (_) {
              _animationController.reverse();
            },
      child: GestureDetector(
          onTapDown: widget.onPressed == null ? null : _handleTapDown,
          onTapUp: widget.onPressed == null ? null : _handleTapUp,
          onTap: widget.onPressed == null ? null : _handleTap,
          onTapCancel: widget.onPressed == null
              ? null
              : () {
                  _animationController.reverse();
                },
          child: AnimatedBuilder(
            animation: _sizeAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _sizeAnimation.value,
                child: child,
              );
            },
            child: AnimatedContainer(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              // onEnd: () {
              //   setState(() {
              //     scaleFactor = _sizeAnimation.value;
              //   });
              // },

              clipBehavior: widget.shouldClip ? Clip.hardEdge : Clip.none,
              padding: widget.padding,
              decoration: BoxDecoration(
                  borderRadius:
                      widget.brad ?? BorderRadius.circular(widget.radius),
                  color: widget.color,
                  border: widget.border,
                  boxShadow: widget.boxshadow,
                  image: widget.image == null
                      ? null
                      : DecorationImage(
                          image: AssetImage(widget.image!), fit: BoxFit.fill)),
              duration: Duration(milliseconds: 300),
              child: widget.child,
            ),
          )),
    );
  }
}

class ShadowContainer extends StatelessWidget {
  const ShadowContainer(
      {required this.child,
      this.padding = 16,
      this.margin = 8,
      this.radius=8,
      this.width,
      this.color = Colors.white,
      this.height,
      this.onPressed,
      super.key});
  final Widget child;
  final double padding, margin,radius;
  final double? width, height;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(margin),
      width: width,
      color: color,
      radius: radius,
      onPressed: onPressed,
      height: height,
      boxshadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ],
      child: child,
    );
  }
}

class AppIcon extends StatelessWidget {
  const AppIcon(this.asset,
      {this.size = 24, this.color = const Color(0xFF1F1D5E), super.key});
  final dynamic asset;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return asset is String
        ? Image.asset(
            asset,
            width: size,
          )
        : Icon(
            asset,
            size: size,
            color: color,
          );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({this.isMap = false, super.key});
  final bool isMap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        // padding:  EdgeInsets.all(8*Ui.dp()),
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF0F3),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: AppIcon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

///This is the general widget for text in this app
///use this rather than the flutter provided text widget
///
/// static methods are provided for fontWeights
/// eg. AppText.semiBoldItalic(
///       "my text",
///       fontSize: 20,
///      )...
///   for -> fontWeight = 600
///          fontSize = 20
///          fontStyle = italic
///
/// if there are font weight that are not provided here
/// feel free to add a  method for it.
/// happy coding :)
///
class AppText extends StatelessWidget {
  final String text;
  final FontWeight? weight;
  final double? fontSize;
  final FontStyle? style;
  final String? fontFamily;
  final Color? color;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextOverflow overflow;
  final int? maxlines;
  final bool shdUseATT;

  ///fontSize = 14
  const AppText(
    this.text, {
    super.key,
    this.weight = FontWeight.w400,
    this.fontSize,
    this.style = FontStyle.normal,
    this.color,
    this.fontFamily,
    this.alignment = TextAlign.start,
    this.shdUseATT = false,
    this.overflow = TextOverflow.visible,
    this.maxlines,
    this.decoration,
  });

  ///fontSize: 15
  ///weight: w700
  static AppText bold(
    String text, {
    Color? color,
    String? fontFamily,
    TextAlign? alignment,
    bool? att,
    double? fontSize = 16,
  }) =>
      AppText(
        text,
        weight: FontWeight.w600,
        fontFamily: fontFamily,
        shdUseATT: att ?? false,
        color: color,
        alignment: alignment,
        fontSize: fontSize,
      );

  ///fontSize: 15
  ///weight: w700
  static AppText proBold(
    String text, {
    Color? color,
    String? fontFamily,
    TextAlign? alignment,
    double? fontSize = 16,
  }) =>
      AppText(
        text,
        weight: FontWeight.w700,
        fontFamily: fontFamily,
        color: color,
        alignment: alignment,
        fontSize: fontSize,
      );

  ///fontSize: 15
  ///weight: w300
  static AppText thin(
    String text, {
    Color? color,
    String? fontFamily,
    TextAlign? alignment,
    bool? att,
    TextOverflow overflow = TextOverflow.visible,
    TextDecoration? decoration,
    double? fontSize = 14,
  }) =>
      AppText(
        text,
        weight: FontWeight.w400,
        color: color,
        alignment: alignment,
        decoration: decoration,
        shdUseATT: att ?? false,
        fontFamily: fontFamily,
        fontSize: fontSize,
        overflow: overflow,
      );

  ///weight: w500
  static AppText medium(
    String text, {
    Color? color,
    String? fontFamily,
    double fontSize = 16,
    TextAlign? alignment,
    TextOverflow overflow = TextOverflow.visible,
  }) =>
      AppText(
        text,
        fontSize: fontSize,
        weight: FontWeight.w500,
        overflow: overflow,
        alignment: alignment,
        fontFamily: fontFamily,
        color: color,
      );

  ///weight: w300
  ///fontSize: 16
  ///color: #FFFFFF
  static AppText button(
    String text, {
    Color color = Colors.white,
    double fontSize = 16,
    TextAlign? alignment,
    TextDecoration? decoration,
  }) =>
      AppText(
        text,
        fontSize: fontSize,
        weight: FontWeight.w400,
        decoration: decoration,
        alignment: alignment,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    final ts = TextStyle(
      decoration: decoration,
      fontSize: (fontSize ?? 14),
      color: color ?? Colors.black,
      fontWeight: weight,
      overflow: overflow,
      fontStyle: style,
      fontFamily: fontFamily,
    );

    if (shdUseATT) {
      return AutoSizeText(
        text,
        maxLines: maxlines ?? 2,
        // softWrap: false,
        wrapWords: false,

        style: ts,
        textAlign: alignment,
      );
    }

    return Text(
      text,
      maxLines: maxlines,
      style: ts,
      textAlign: alignment,
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final double size, padding;

  const LoadingIndicator({this.size = 24, this.padding = 0, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          height: size,
          width: size,
          child: const CircularProgressIndicator(
            color: Colors.black,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatefulWidget {
  final Function? onPressed;
  final Widget? child;
  final String? text, icon;
  final bool? disabled;
  final Color color, borderColor;
  final bool isCircle, isWide, hasBorder;

  const AppButton({
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.disabled,
    this.isWide = true,
    this.isCircle = false,
    this.borderColor = Colors.white,
    this.hasBorder = false,
    this.color = Colors.black,
    super.key,
  });

  @override
  State<AppButton> createState() => _AppButtonState();

  static social(
    Function? onPressed,
    String icon,
  ) {
    return AppButton(
      onPressed: onPressed,
      icon: icon,
      color: Colors.white,
      isCircle: true,
    );
  }

  static half(
    Function? onPressed,
    String title,
  ) {
    return AppButton(
      onPressed: onPressed,
      text: title,
      isWide: false,
    );
  }

  static white(
    Function? onPressed,
    String title,
  ) {
    return AppButton(
      onPressed: onPressed,
      color: Colors.white,
      text: title,
    );
  }

  static outline(Function? onPressed, String title,
      {Color color = Colors.white, String? icon}) {
    return AppButton(
      onPressed: onPressed,
      hasBorder: true,
      icon: icon,
      borderColor: Colors.black,
      text: title,
      color: color,
    );
  }

  static column(String titleA, Function? onPressedA, String titleB,
      Function? onPressedB) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton(
          onPressed: onPressedA,
          text: titleA,
        ),
        Ui.boxHeight(16),
        outline(onPressedB, titleB)
      ],
    );
  }

  static row(String titleA, Function? onPressedA, String titleB,
      Function? onPressedB) {
    return Row(
      children: [
        Expanded(child: outline(onPressedB, titleB)),
        Ui.boxWidth(24),
        Expanded(
          child: AppButton(
            onPressed: onPressedA,
            text: titleA,
          ),
        )
      ],
    );
  }

  static title(String title, VoidCallback? onPressed,
      {Color tColor = Colors.black}) {
    return InkWell(
      onTap: onPressed,
      child: Ui.padding(
          padding: 8, child: AppText.thin(title, fontSize: 16, color: tColor)),
    );
  }
}

class _AppButtonState extends State<AppButton> {
  bool disabled = false;
  bool isPressed = false;

  @override
  void initState() {
    disabled = widget.disabled ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    disabled = widget.disabled ?? false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: disabled ? Colors.grey : widget.color,
      elevation: widget.hasBorder ? 0 : 2,
      shape: widget.isCircle
          ? const CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: Ui.circularRadius(8),
              side: widget.hasBorder
                  ? BorderSide(color: widget.borderColor)
                  : BorderSide.none,
            ),
      onPressed: (disabled || widget.onPressed == null)
          ? null
          : () async {
              setState(() {
                disabled = true;
                isPressed = true;
              });
              await widget.onPressed!();
              setState(() {
                disabled = false;
                isPressed = false;
              });
            },
      child: widget.isCircle
          ? Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: disabled
                      ? const LoadingIndicator()
                      : Image.asset(widget.icon!)),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              width: widget.isWide
                  ? double.maxFinite
                  : (Ui.width(context) / 2) - 36,
              child: Center(
                child: !isPressed
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null)
                            AppIcon(
                              widget.icon,
                              color: null,
                            ),
                          if (widget.icon != null) Ui.boxWidth(16),
                          widget.child ??
                              AppText.button(
                                widget.text!,
                                alignment: TextAlign.center,
                                color: widget.hasBorder
                                    ? widget.borderColor
                                    : widget.color == Colors.white
                                        ? Colors.black
                                        : Colors.white,
                              ),
                        ],
                      )
                    : const LoadingIndicator(),
              )),
    );
  }
}

abstract class Ui {
  static SizedBox boxHeight(double height) => SizedBox(height: height);

  static SizedBox boxWidth(double width) => SizedBox(width: width);

  ///All padding
  static Padding padding({Widget? child, double padding = 16}) => Padding(
        padding: EdgeInsets.all(padding),
        child: child,
      );

  static Align align({Widget? child, Alignment align = Alignment.centerLeft}) =>
      Align(
        alignment: align,
        child: child,
      );

  static BorderRadius circularRadius(double radius) => BorderRadius.all(
        Radius.circular(radius),
      );

  static Spacer spacer() => const Spacer();

  static BorderRadius topRadius(double radius) => BorderRadius.vertical(
        top: Radius.circular(radius),
      );

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isSmallScreen(BuildContext context) {
    return width(context) < 330;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static BorderRadius bottomRadius(double radius) => BorderRadius.vertical(
        bottom: Radius.circular(radius),
      );

  static BorderSide simpleBorderSide({Color color = Colors.grey}) => BorderSide(
        color: color,
        width: 1,
      );

  static showInfo(String message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      messageText: AppText.thin(message,
          fontSize: 14, color: Colors.black, alignment: TextAlign.center),
      boxShadows: [
        BoxShadow(offset: Offset(0, -4), blurRadius: 40, color: Colors.white)
      ],
      backgroundColor: Colors.white,
      borderRadius: 16,
      forwardAnimationCurve: Curves.elasticInOut,
      snackPosition: SnackPosition.TOP,
      animationDuration: Duration(milliseconds: 1500),
      duration: Duration(seconds: 5),
      padding: EdgeInsets.all(24),
      isDismissible: true,
      margin: EdgeInsets.only(left: 24, right: 24, top: 24),
    ));
  }

  static showError(String message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(GetSnackBar(
      snackPosition: SnackPosition.TOP,
      messageText: AppText.thin(message, fontSize: 14, color: Colors.white),
      boxShadows: [
        BoxShadow(offset: Offset(0, -4), blurRadius: 40, color: Colors.white)
      ],
      shouldIconPulse: true,
      icon: AppIcon(
        Icons.dangerous_outlined,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
      borderRadius: 16,
      duration: Duration(seconds: 5),
      margin: EdgeInsets.only(left: 24, right: 24, top: 24),
    ));
  }

  static showBottomSheet(String title, String message, Widget backWidget,
      {Function? yesBtn}) {
    Get.bottomSheet(
        Ui.padding(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AppText.medium(title, fontSize: 24),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
              Ui.boxHeight(16),
              AppText.thin(message),
              Ui.boxHeight(24),
              Row(
                children: [
                  Expanded(
                      child: AppButton.outline(() {
                    Get.back();
                  }, "No", color: Colors.white)),
                  Ui.boxWidth(16),
                  Expanded(
                      child: AppButton(
                          onPressed: () async {
                            if (yesBtn != null) await yesBtn();
                            Get.offAll(backWidget);
                          },
                          text: "Yes")),
                ],
              ),
              Ui.boxHeight(24),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))));
  }

  static InputDecoration simpleInputDecoration({
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
  }) =>
      InputDecoration(
        border: Ui.outlinedInputBorder(),
        contentPadding: contentPadding,
        fillColor: fillColor,
        errorBorder: Ui.outlinedInputBorder(),
        focusedBorder: Ui.outlinedInputBorder(),
        enabledBorder: Ui.outlinedInputBorder(),
      );

  ///decoration for text fields without a border
  static InputDecoration denseInputDecoration({
    EdgeInsetsGeometry? contentPadding,
    Color fillColor = Colors.grey,
  }) =>
      InputDecoration(
        border: Ui.denseOutlinedInputBorder(),
        contentPadding: contentPadding,
        fillColor: fillColor,
        filled: true,
        errorBorder: Ui.denseOutlinedInputBorder(),
        focusedErrorBorder: Ui.denseOutlinedInputBorder(),
        focusedBorder: Ui.denseOutlinedInputBorder(),
        enabledBorder: Ui.denseOutlinedInputBorder(),
      );

  static InputBorder outlinedInputBorder({
    double circularRadius = 5,
  }) =>
      OutlineInputBorder(
        borderRadius: Ui.circularRadius(circularRadius),
      );

  static InputBorder denseOutlinedInputBorder({
    double circularRadius = 5,
  }) =>
      OutlineInputBorder(
          borderRadius: Ui.circularRadius(circularRadius),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 0,
          ));

  static dynamic backgroundImage(String url) => DecorationImage(
      image:
          url.startsWith("http") ? NetworkImage(url) : Image.asset(url).image);
}

class AppDialog extends StatelessWidget {
  const AppDialog({required this.title, required this.content, super.key});
  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: title),
          SizedBox(
            width: 24,
            child: InkWell(
                mouseCursor: SystemMouseCursors.click,
                onTap: () {
                  Get.back();
                },
                child: AppIcon(
                  Icons.close,
                  color: Colors.red,
                )),
          )
        ],
      ),
      titlePadding: EdgeInsets.only(top: 24, left: 16, right: 16),
      content: SizedBox(width: Ui.width(context) / 3, child: content),
      backgroundColor: Colors.white,
    );
  }

  static empty(Widget content){
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 24, left: 16, right: 16),
      content: content,
      backgroundColor: Colors.white,
    );
  }

  static normal(String title, String body,
      {String titleA = "",
      Function? onPressedA,
      String titleB = "",
      Function? onPressedB}) {
    return AppDialog(
      title: Align(
          alignment: Alignment.center,
          child: AppText.medium(title, fontSize: 18)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.thin(body),
          Ui.boxHeight(24),
          AppButton.column(titleA, onPressedA, titleB, onPressedB),
        ],
      ),
    );
  }

  static normalIcon(dynamic icon, String body,
      {String titleA = "",
      Function? onPressedA,
      String titleB = "",
      Function? onPressedB}) {
    return AppDialog(
      title: AppIcon(icon),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.thin(body),
          Ui.boxHeight(24),
          AppButton.column(titleA, onPressedA, titleB, onPressedB),
        ],
      ),
    );
  }

  static status({String body = "", String? icon}) {
    return AppDialog(
        title: icon == null ? SizedBox() : AppIcon(icon),
        content: AppText.thin(body));
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color col, iconColor;
  final VoidCallback? onTap, customOnChanged;
  final TextInputAction tia;
  final dynamic suffix, prefix;
  final bool autofocus, hasBottomPadding, isDense;
  final double fs;
  final FontWeight fw;
  final TextInputType tk;
  final bool readOnly, isWide, shdValidate, isPassword;
  final TextAlign textAlign;
  final String? oldPass, hint;
  final double? ww;
  const CustomTextField(this.label, this.controller,
      {this.fs = 16,
      this.hint,
      this.hasBottomPadding = true,
      this.fw = FontWeight.w300,
      this.col = Colors.black,
      this.iconColor = Colors.black,
      this.tia = TextInputAction.next,
      this.isDense = true,
      this.isPassword = false,
      this.prefix,
      this.oldPass,
      this.onTap,
      this.tk = TextInputType.text,
      this.isWide = true,
      this.autofocus = false,
      this.customOnChanged,
      this.readOnly = false,
      this.shdValidate = true,
      this.textAlign = TextAlign.start,
      this.ww,
      this.suffix,
      super.key});

  @override
  Widget build(BuildContext context) {
    Color borderCol = Colors.grey;
    bool hasTouched = true;
    bool isLabel = label != "";
    final w = isWide ? Ui.width(context) : Ui.width(context) / 2;
    final isDisabled =  readOnly && onTap == null;

    return StatefulBuilder(builder: (context, setState) {
      return SizedBox(
        width: ww ?? (w - 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLabel) AppText.thin(label, color: Colors.black),
            if (isLabel)
              const SizedBox(
                height: 4,
              ),
            TextFormField(
              controller: controller,
              readOnly: readOnly,
              textAlign: textAlign,
              autofocus: autofocus,
              onChanged: (s) async {
                // if (s.isNotEmpty) {
                //   setState(() {
                //     hasTouched = true;
                //   });
                // } else {
                //   setState(() {
                //     hasTouched = false;
                //   });
                // }
                if (customOnChanged != null) customOnChanged!();
              },
              keyboardType: tk,
              maxLines: tk == TextInputType.text ? null : 5,
              textInputAction: tia,
              obscureText: isPassword ? hasTouched : false,
              onTap: onTap,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(fontSize: fs, fontWeight: fw, color: col),
              decoration: InputDecoration(
                fillColor: isDisabled ? Colors.grey : Colors.white,
                filled: true,
                enabledBorder: customBorder(color: borderCol),
                focusedBorder: customBorder(color: borderCol),
                border: customBorder(color: borderCol),
                focusedErrorBorder: customBorder(color: Colors.red),
                counter: SizedBox.shrink(),
                errorStyle: TextStyle(fontSize: 12, color: Colors.red),
                errorBorder: customBorder(color: borderCol),
                suffixIconConstraints: suffix != null
                    ? BoxConstraints(minWidth: 24, minHeight: 24)
                    : null,
                isDense: isDense,
                prefixIcon: prefix == null
                    ? null
                    : SizedBox(
                        width: 48,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0, right: 0),
                            child: AppText.thin(prefix, fontSize: 16),
                          ),
                        ),
                      ),
                suffixIcon: suffix != null
                    ? Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              hasTouched = !hasTouched;
                            });
                          },
                          child: AppIcon(suffix, color: iconColor),
                        ),
                      )
                    : null,
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: fs,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey),
              ),
            ),
            SizedBox(
              height: hasBottomPadding ? 24 : 0,
            )
          ],
        ),
      );
    });
  }

  static bool isUserVal(String s) {
    return !(s.isEmpty || s.contains(RegExp(r'[^\w.]')) || s.length < 8);
  }

  OutlineInputBorder customBorder({Color color = Colors.black}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8),
      gapPadding: 8,
    );
  }
}

class SimpleTextClock extends StatefulWidget {
  

  const SimpleTextClock({
    super.key
  });

  @override
  State<SimpleTextClock> createState() => _SimpleTextClockState();
}

class _SimpleTextClockState extends State<SimpleTextClock> {
  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('d MMMM yyyy h:mm:ss a');
    setState(() {
      _currentTime = formatter.format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12),
      child: AppText.thin(_currentTime),
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Color col, iconColor;
  final VoidCallback? onTap;
  final dynamic prefix;
  final bool autofocus, hasBottomPadding, isDense;
  final double fs;
  final FontWeight fw;
  final bool readOnly, isWide;
  final TextAlign textAlign;
  final String? hint;
  final double? ww;

  const CustomDropdown(
    this.label,
    this.items, {
    this.value,
    this.onChanged,
    this.fs = 16,
    this.hint,
    this.hasBottomPadding = true,
    this.fw = FontWeight.w300,
    this.col = Colors.black,
    this.iconColor = Colors.black,
    this.isDense = true,
    this.prefix,
    this.onTap,
    this.isWide = true,
    this.autofocus = false,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.ww,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color borderCol = Colors.grey;
    bool isLabel = label != "";
    final w = isWide ? Ui.width(context) : Ui.width(context) / 2;
    final isDisabled = readOnly && onTap == null;

    return SizedBox(
      width: ww ?? (w - 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLabel) AppText.thin(label, color: Colors.black),
          if (isLabel)
            const SizedBox(
              height: 4,
            ),
          DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: readOnly ? null : onChanged,
            onTap: onTap,
            autofocus: autofocus,
            style: TextStyle(fontSize: fs, fontWeight: fw, color: col),
            dropdownColor: Colors.white,
            iconEnabledColor: iconColor,
            iconDisabledColor: Colors.grey,
            decoration: InputDecoration(
              fillColor: isDisabled ? Colors.grey : Colors.white,
              filled: true,
              enabledBorder: customBorder(color: borderCol),
              focusedBorder: customBorder(color: borderCol),
              border: customBorder(color: borderCol),
              focusedErrorBorder: customBorder(color: Colors.red),
              errorStyle: TextStyle(fontSize: 12, color: Colors.red),
              errorBorder: customBorder(color: borderCol),
              isDense: isDense,
              prefixIcon: prefix == null
                  ? null
                  : SizedBox(
                      width: 48,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, right: 0),
                          child: AppText.thin(prefix, fontSize: 16),
                        ),
                      ),
                    ),
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: fs,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: hasBottomPadding ? 24 : 0,
          )
        ],
      ),
    );
  }

  OutlineInputBorder customBorder({Color color = Colors.black}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(8),
      gapPadding: 8,
    );
  }
}

class AppHeader extends StatelessWidget {
  const AppHeader(
      {this.title = "Calibration Tracker - Dangote Refinery",
      this.desc =
          "Flowmeters across 10 gantries • Track internal checks & external calibrations",
      this.trailing,
      super.key});
  final String title, desc;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      padding: EdgeInsets.only(left: 56, right: 56, top: 16, bottom: 16),
      child: Row(
        children: [
          CurvedContainer(
              radius: 16,
              color: const Color(0xFF1F1D5E),
              padding: EdgeInsets.all(8),
              child: AppIcon(
                Icons.settings,
                color: Colors.white,
              )),
          Ui.boxWidth(24),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bold(title),
                Ui.boxHeight(4),
                AppText.thin(desc, fontSize: 12),
              ],
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}

class AppHeader2 extends StatelessWidget {
  const AppHeader2(
      {this.title = "Calibration Tracker - Dangote Refinery",
      this.desc =
          "Flowmeters across 10 gantries • Track external calibrations",
      this.trailing,
      super.key});
  final String title, desc;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
      padding: EdgeInsets.only(left: 56, right: 56, top: 4, bottom: 4),
      child: Row(
        children: [
          CurvedContainer(
              radius: 8,
              color: const Color(0xFF1F1D5E),
              padding: EdgeInsets.all(8),
              child: AppIcon(
                Icons.dashboard,
                size: 16,
                color: Colors.white,
              )),
          Ui.boxWidth(24),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bold(title),
                AppText.thin(desc, fontSize: 12),
              ],
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}

class BlinkingContainer extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final Color beginColor;
  final Color endColor;

  const BlinkingContainer({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.beginColor = Colors.red,
    this.endColor = Colors.red,
  });

  @override
  State<BlinkingContainer> createState() => _BlinkingContainerState();
}

class _BlinkingContainerState extends State<BlinkingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  Timer? _blinkTimer;
  int _blinkCount = 0;

  @override
  void initState() {
    super.initState();

    // Setup animation controller for a single blink
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create color tween animation
    _colorAnimation = ColorTween(
      begin: widget.beginColor,
      end: widget.endColor,
    ).animate(_controller);

    // Setup periodic timer for triggering blinks
    _blinkTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _startBlinkSequence();
    });

    // Start first blink sequence
    _startBlinkSequence();
  }

  void _startBlinkSequence() {
    _blinkCount = 0;
    _blink();
  }

  void _blink() {
    if (_blinkCount >= 3) return;

    // Forward animation (fade in)
    _controller.forward().then((_) {
      // Reverse animation (fade out)
      _controller.reverse().then((_) {
        _blinkCount++;
        if (_blinkCount < 3) {
          _blink(); // Continue blinking if we haven't done 3 times
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return CurvedContainer(
          radius: 0,
          color: _colorAnimation.value ?? widget.beginColor,
          width: widget.width,
          height: 48,
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Center(child: widget.child),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }
}

class AppChip extends StatelessWidget {
  const AppChip(this.title, this.color, {this.hasBorder = false,this.fontsize=15, super.key});
  final Color color;
  final String title;
  final bool hasBorder;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: AppText.thin(title,
          fontSize: fontsize, color: color, alignment: TextAlign.center),
      backgroundColor: color.withOpacity(0.1),
      side: hasBorder
          ? BorderSide(color: color.withOpacity(0.3))
          : BorderSide.none,
      padding: EdgeInsets.all(4),
    );
  }
}

class AppChip2 extends StatelessWidget {
  const AppChip2(this.title, this.color,this.tcolor, {this.hasBorder = false,this.fontsize=15, super.key});
  final Color color,tcolor;
  final String title;
  final bool hasBorder;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return CurvedContainer(
          color: color,
          radius: 0,
      border: hasBorder
          ? Border.all(color: color.withOpacity(0.3))
          : Border(),
          child: Center(
            child: AppText.thin(title,
                  fontSize: fontsize, color: tcolor, alignment: TextAlign.center),
          ),
        );
  }
}

class AppChipCell extends StatelessWidget {
  const AppChipCell(this.text, {this.status = 0, this.desc, super.key});
  final int status;
  final String text;
  final String? desc;

  @override
  Widget build(BuildContext context) {
    final color = status == 0
        ? const Color.fromARGB(255, 173, 12, 0)
        : status == 1
            ? const Color.fromARGB(255, 0, 87, 3)
            : const Color.fromARGB(255, 0, 68, 124);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ui.boxHeight(4),
        AppChip(
          text,
          color,
        ),
        if (desc != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 8),
            child: AppText.thin(desc!,
                fontSize: 12,
                color: Colors.grey.shade400,
                alignment: TextAlign.center),
          ),
      ],
    );
  }
}

class AppTextCell extends StatelessWidget {
  const AppTextCell(this.text,
      {this.desc,
      this.boldTitle = false,
      this.color = Colors.black,
      super.key});
  final String text;
  final String? desc;
  final bool boldTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Ui.boxHeight(4),
        boldTitle
            ? AppText.bold(text,
                alignment: TextAlign.center, fontSize: 14, color: color)
            : AppText.thin(text, alignment: TextAlign.center, color: color),
        if (desc != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 8),
            child: AppText.thin(desc!,
                fontSize: 12,
                color: Colors.grey.shade400,
                alignment: TextAlign.center),
          ),
      ],
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.primary.withOpacity(0.1),
    );
  }
}

class MonthPicker extends StatelessWidget {
  const MonthPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final w = ((Ui.width(context) / 3)-48)/5;
    RxInt year = 2025.obs;
    return AppDialog(
        title: AppText.bold("Select Month"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
               () {
                return DropdownButton(
                    value: year.value,
                    items: List.generate(
                        5,
                        (i) => DropdownMenuItem(
                              child: AppText.thin((2025 - (4 - i)).toString()),
                              value: 2025 - (4 - i),
                            )),
                    onChanged: (i) {
                      year.value = i ?? 2025;
                    });
              }
            ),
            Ui.boxHeight(8),
            Wrap(
              runSpacing: 16,
              spacing: 16,
              children: List.generate(12, (i) {
                return ShadowContainer(
                    width: w,
                    padding: 16,
                    margin: 0,
                    onPressed: (){
                      Get.back(result: DateTime(year.value, i + 1, 1));
                    },
                    child: Center(
                      child: AppText.thin(
                          DateFormat("MMMM").format(DateTime(2024, i + 1, 1)),alignment: TextAlign.center),
                    ));
              }),
            )
          ],
        ));
  }
}
