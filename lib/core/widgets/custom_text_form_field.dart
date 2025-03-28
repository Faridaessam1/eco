import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextFormField extends StatefulWidget{
  String? iconPath;
  bool hasIcon;
  String hintText;
  String? Function(String?)? validator;
  bool isPassword;
  int? maxLines;
  int? minLines;
  Color? hintTextColor;
  Color? iconColor;
  Color? borderColor;
  Color filledColor;
  TextEditingController? controller;

  CustomTextFormField({
    super.key,
    this.iconPath, //lw fe icon gwa l border
    this.hasIcon = true,
    required this.hintText,
    this.validator,
    this.isPassword = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.hintTextColor,
    this.iconColor,
    this.borderColor,
    this.controller,
    required this.filledColor
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      validator: widget.validator,
      obscureText: widget.isPassword ? obscureText : false, //lw el textfield password khale yakhod value el obsuretext lw la yeb2a khlas ehna msh obscure
      obscuringCharacter: "*",
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.filledColor,
        prefixIcon: widget.hasIcon && widget.iconPath  != null
            ? Padding(
          padding: const EdgeInsets.all(9.0),
          child: ImageIcon(
            AssetImage(widget.iconPath!),
            color: widget.iconColor ?? AppColors.primaryColor,
          ),
        ) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: widget.iconColor ?? AppColors.primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    // kol ma luser y3ml press bnghyr el value lw true tkon false w l3ks
                    obscureText = !obscureText;
                  });
                },
              )
            : null,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: widget.hintTextColor ?? AppColors.primaryColor,
            ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: widget.borderColor ?? AppColors.primaryColor,
            )),
        focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color:  widget.borderColor ?? AppColors.primaryColor,
            )
        ),

        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.red,
            )),
      ),
    );
  }
}