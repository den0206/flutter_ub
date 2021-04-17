import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    @required this.title,
    this.backColor = BrandColors.colorGreen,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Color backColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: backColor,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    Key key,
    @required this.title,
    this.isSecure = false,
    @required this.onChangged,
    @required this.validator,
  }) : super(key: key);

  final String title;
  final bool isSecure;

  final FormFieldValidator<String> validator;
  final ValueChanged<String> onChangged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isSecure,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 10,
        ),
      ),
      style: TextStyle(
        fontSize: 14,
      ),
      validator: validator,
      onChanged: onChangged,
    );
  }
}
