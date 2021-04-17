import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ub/app/extension/validation.dart';

enum CustomTextType {
  fullname,
  email,
  password,
  phone,
}

extension CustomTextExtension on CustomTextType {
  String get title {
    switch (this) {
      case CustomTextType.email:
        return "Email";
      case CustomTextType.password:
        return "Password";
      case CustomTextType.fullname:
        return "Fullname";
      case CustomTextType.phone:
        return "Phone";
      default:
        return "";
    }
  }

  FormFieldValidator<String> get validation {
    switch (this) {
      case CustomTextType.email:
        return validateEmail;
      case CustomTextType.password:
        return validPassword;
      case CustomTextType.fullname:
        return valideName;
      case CustomTextType.phone:
        return validPhone;
      default:
        return null;
    }
  }

  bool get isSecure {
    switch (this) {
      case CustomTextType.password:
        return true;
      default:
        return false;
    }
  }

  TextInputType get inputType {
    switch (this) {
      case CustomTextType.fullname:
        return TextInputType.text;
      case CustomTextType.email:
        return TextInputType.emailAddress;

      case CustomTextType.phone:
        return TextInputType.phone;
      default:
        return null;
    }
  }

  List<TextInputFormatter> get formatter {
    switch (this) {
      case CustomTextType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }
}

class CustomTextFields extends StatelessWidget {
  const CustomTextFields({
    Key key,
    @required this.type,
    @required this.onChangged,
  }) : super(key: key);

  final CustomTextType type;
  final ValueChanged<String> onChangged;
  // final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: type.title,
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
      keyboardType: type.inputType,
      obscureText: type.isSecure,
      inputFormatters: type.formatter,
      validator: type.validation,
      onChanged: onChangged,
    );
  }
}
