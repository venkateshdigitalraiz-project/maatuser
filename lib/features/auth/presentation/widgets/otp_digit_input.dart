import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class OtpDigitInput extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onChanged;
  final bool hasError;

  const OtpDigitInput({
    super.key,
    this.length = 4,
    required this.onCompleted,
    required this.onChanged,
    this.hasError = false,
  });

  @override
  State<OtpDigitInput> createState() => OtpDigitInputState();
}

class OtpDigitInputState extends State<OtpDigitInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get currentOtp => _controllers.map((c) => c.text).join();

  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    if (_focusNodes.isNotEmpty) {
      _focusNodes[0].requestFocus();
    }
    widget.onChanged('');
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length; i++) {
        final targetIndex = index + i;
        if (targetIndex < widget.length && i < digits.length) {
          _controllers[targetIndex].text = digits[i];
        }
      }
      final fullOtp = currentOtp;
      widget.onChanged(fullOtp);
      if (fullOtp.length == widget.length) {
        widget.onCompleted(fullOtp);
        _focusNodes.last.unfocus();
      } else {
        final nextEmpty = _controllers.indexWhere((c) => c.text.isEmpty);
        if (nextEmpty != -1) {
          _focusNodes[nextEmpty].requestFocus();
        }
      }
      return;
    }

    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    final fullOtp = currentOtp;
    widget.onChanged(fullOtp);

    if (fullOtp.length == widget.length) {
      widget.onCompleted(fullOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final bool isFocused = _focusNodes[index].hasFocus;
        final bool isFilled = _controllers[index].text.isNotEmpty;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == widget.length - 1 ? 0 : 8,
            ),
            height: 64,
            decoration: BoxDecoration(
              color: isFocused
                  ? Colors.white
                  : isFilled
                      ? const Color(0xFFF9FAFB)
                      : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.hasError
                    ? AppColors.error
                    : isFocused
                        ? AppColors.accentYellowDark
                        : isFilled
                            ? AppColors.primary
                            : AppColors.border,
                width: isFocused ? 2.2 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: isFocused
                      ? AppColors.accentYellow.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: isFocused ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace) {
                    if (_controllers[index].text.isEmpty && index > 0) {
                      _controllers[index - 1].clear();
                      _focusNodes[index - 1].requestFocus();
                      widget.onChanged(currentOtp);
                    }
                  }
                },
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: widget.hasError ? AppColors.error : AppColors.textPrimary,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (val) => _onDigitChanged(index, val),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
