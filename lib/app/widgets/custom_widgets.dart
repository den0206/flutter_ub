import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key key,
    this.height = 50,
    @required this.width,
    @required this.title,
    @required this.onPressed,
    this.backColor = BrandColors.colorGreen,
  }) : super(key: key);

  final double height;
  final double width;

  final String title;
  final Color backColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
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
      ),
    );
  }
}

Future showErrorDialog(BuildContext context, error) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Error"),
        content: Text("${error.message} Error"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
