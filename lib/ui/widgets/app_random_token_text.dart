
import 'dart:math';

import 'package:flutter/material.dart';


class RandomTextSource {
  static const digits = '0123456789';
  static const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const alphabets = '$uppercase$lowercase';
  static const token = '$uppercase$lowercase$digits';
  static const specialCharacters = '`~!@#\$%^&*()_+-=[]{}\\|;:\'".>/?';
  static const all = '$digits$alphabets$specialCharacters';
}

class AppRandomTokenText extends StatefulWidget {

  /// Creates an animated text widget.
  ///
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ///
  /// The [overflow] property's behavior is affected by the [softWrap] argument.
  /// If the [softWrap] is true or null, the glyph causing overflow, and those that follow,
  /// will not be rendered. Otherwise, it will be shown with the given overflow option.
  const AppRandomTokenText({
    Key? key,
    required this.text,
    this.style,
    this.randomString = RandomTextSource.token,
    this.duration = const Duration(seconds: 2),
    this.onFinished,
    this.curve = Curves.easeIn,
    this.textDirection = TextDirection.ltr,
    this.locale,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textAlign,
    this.semanticsLabel,
  }) : super(key: key);

  /// The text to display.
  final String text;

  /// The text from which random characters will be displayed before
  /// the actual character
  final String randomString;

  /// The length of time this animation should last.
  final Duration duration;

  /// A function which will be triggered at the end of animation
  final VoidCallback? onFinished;

  /// A collection of common animation curves.
  final Curve curve;

  /// The style of the text with specified color, fontWeight, fontSize
  final TextStyle? style;

  /// Represents directionality of text.
  final TextDirection? textDirection;

  /// The Locale used for multiple language support
  final Locale? locale;

  /// The maximum number of lines of the text to be displayed before cropping
  final int? maxLines;

  /// The type of overflow in text
  final TextOverflow? overflow;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// An alternative semantics label for this text.
  final String? semanticsLabel;

  @override
  State<AppRandomTokenText> createState() => _AppRandomTokenTextState();
}

class _AppRandomTokenTextState extends State<AppRandomTokenText>with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.text.length.toDouble(),
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    play();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _animatedText(text: widget.text, value: _animation.value.toInt()),
      style: widget.style,
      textDirection: widget.textDirection,
      locale: widget.locale,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      softWrap: widget.softWrap,
      textAlign: widget.textAlign,
      semanticsLabel: widget.semanticsLabel,
    );
  }

  String _animatedText({required String text, required int value}) {
    if (value == text.length) {
      widget.onFinished?.call();
      return text;
    }

    String substring = text.substring(0, value);

    int len = text.length - substring.length;

    final random = Random();
    final randomString = StringBuffer();

    for (int i = 0; i < len; i++) {
      int index = random.nextInt(widget.randomString.length);
      randomString.writeCharCode(
        widget.randomString.codeUnitAt(index),
      );
    }

    return '$substring${randomString.toString()}';
  }

  void play({double from = 0}) {
    _controller.forward(from: from);
  }

}