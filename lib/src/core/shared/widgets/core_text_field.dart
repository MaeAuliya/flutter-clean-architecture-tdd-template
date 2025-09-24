import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/colours.dart';
import '../../res/fonts.dart';
import '../../res/texts.dart';
import '../../res/typography.dart';

class CoreTextField extends StatelessWidget {
  const CoreTextField({
    super.key,
    this.validator,
    required this.controller,
    this.filled = false,
    this.fillColor,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixText,
    this.prefixOnTap,
    this.hintText,
    this.keyboardType,
    this.maxLength,
    this.textAlign = TextAlign.start,
    this.overrideValidator = false,
    this.hintStyle,
    this.width,
    this.showCursor,
    this.onTap,
    this.onChanged,
    this.showHint,
    this.errorMessage,
    this.borderColor,
    this.isColorReadOnlyChanged = false,
    this.height,
    this.minHeight,
    this.activeBorder,
    this.contentPadding,
    this.obscuringCharacter,
    this.fontWeight = CoreTypography.medium,
    this.focusNode,
    this.onSubmitted,
    this.onTapOutside,
    this.inputFormatters,
    this.isBorderColorReadOnlyChange = true,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool filled;
  final Color? fillColor;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? prefixText;
  final void Function()? prefixOnTap;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool overrideValidator;
  final TextStyle? hintStyle;
  final double? width;
  final TextAlign textAlign;
  final bool? showCursor;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool? showHint;
  final String? errorMessage;
  final Color? borderColor;
  final bool isColorReadOnlyChanged;
  final int? height;
  final int? minHeight;
  final Color? activeBorder;
  final String? obscuringCharacter;
  final EdgeInsetsGeometry? contentPadding;
  final FontWeight fontWeight;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;
  final List<TextInputFormatter>? inputFormatters;
  final bool isBorderColorReadOnlyChange;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, state) {
        return SizedBox(
          width: width ?? state.maxWidth,
          child: Stack(
            children: [
              TextFormField(
                cursorColor: Colours.primaryBlue,
                minLines: minHeight,
                focusNode: focusNode,
                maxLines: height ?? 1,
                onFieldSubmitted: onSubmitted,
                onTapOutside:
                    onTapOutside ??
                    (event) {
                      if (Platform.isIOS) {
                        FocusScope.of(context).unfocus();
                      } else {
                        return;
                      }
                    },
                enableInteractiveSelection: onTap == null,
                controller: controller,
                showCursor: showCursor,
                cursorWidth: showCursor == false ? 0 : 2,
                validator: overrideValidator
                    ? validator
                    : (value) {
                        if (value == null || value.isEmpty) {
                          return Texts.errorEmptyField;
                        }
                        return validator?.call(value);
                      },
                inputFormatters:
                    inputFormatters ??
                    [
                      if (keyboardType == TextInputType.number)
                        FilteringTextInputFormatter.digitsOnly,
                      if (maxLength != null)
                        LengthLimitingTextInputFormatter(maxLength),
                    ],
                textAlign: textAlign,
                onTap: onTap,
                onChanged: onChanged,
                keyboardType: keyboardType,
                obscureText: obscureText,
                obscuringCharacter: obscuringCharacter ?? '•',
                style: TextStyle(
                  fontSize: 14,
                  color: (readOnly && isColorReadOnlyChanged == false)
                      ? Colours.gray300
                      : Colours.black,
                  fontFamily: Fonts.roboto,
                  fontWeight: fontWeight,
                  height: 24 / 14,
                ),
                readOnly: readOnly,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: borderColor ?? Colours.gray300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: (readOnly && isBorderColorReadOnlyChange)
                          ? Colours.gray300
                          : activeBorder ?? Colours.primaryBlue,
                    ),
                  ),
                  contentPadding:
                      contentPadding ??
                      const EdgeInsets.only(right: 20, left: 20, top: 12),
                  filled: filled,
                  fillColor: fillColor,
                  suffixIcon: suffixIcon,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  prefixStyle: const TextStyle(
                    fontSize: 14,
                    color: Colours.primaryBlue,
                    fontFamily: Fonts.roboto,
                    fontWeight: CoreTypography.bold,
                    height: 24 / 14,
                  ),
                  errorText: errorMessage,
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Colours.errorColor),
                  ),
                  errorMaxLines: 2,
                  prefixIcon:
                      prefixIcon ??
                      (prefixText != null
                          ? GestureDetector(
                              onTap: prefixOnTap,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  prefixText!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colours.gray400,
                                    fontFamily: Fonts.roboto,
                                    fontWeight: CoreTypography.medium,
                                    height: 24 / 14,
                                  ),
                                ),
                              ),
                            )
                          : null),
                  hintText: showHint == null ? hintText : null,
                  hintStyle: showHint == null
                      ? hintStyle ??
                            const TextStyle(
                              fontSize: 12,
                              color: Colours.gray300,
                              fontFamily: Fonts.roboto,
                              fontWeight: CoreTypography.medium,
                              height: 24 / 12,
                              fontStyle: FontStyle.italic,
                            )
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
