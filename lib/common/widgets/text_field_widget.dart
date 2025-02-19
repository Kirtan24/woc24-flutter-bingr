import 'package:bingr/util/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TextFieldWidget extends StatefulWidget {
  final Icon prefixIcon;
  final String hintText;
  final bool isPasswordField;
  final String? errorText;
  final FocusNode? focusNode;
  final IconButton? suffixIcon;
  final TextEditingController? textEditingController;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;

  const TextFieldWidget({
    super.key,
    required this.prefixIcon,
    required this.hintText,
    this.isPasswordField = false,
    this.errorText = "error",
    this.focusNode,
    this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.onTap,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isObscured = true; // Tracks whether the password is hidden

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          // showCursor: false,
          controller: widget.textEditingController,
          obscureText: widget.isPasswordField && _isObscured,
          cursorOpacityAnimates: true,
          cursorColor:
              BHelperFunction.isDarkMode(context) ? Colors.white : Colors.black,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            prefixIcon: IconTheme(
              data: IconTheme.of(context),
              child: IconTheme(
                data: IconTheme.of(context),
                child: widget.prefixIcon,
              ),
            ),
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Iconsax.eye : Iconsax.eye_slash,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured; // Toggle the visibility
                      });
                    },
                  )
                : widget.suffixIcon,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            filled: true,
            fillColor: Colors.transparent, // Background color for the field
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.grey, // Always grey for enabled state
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDarkMode
                    ? Colors.white
                    : Colors.black, // Dynamic focused color
                width: 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.red, // Error underline color
                width: 2.0,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.redAccent, // Error border when focused
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
