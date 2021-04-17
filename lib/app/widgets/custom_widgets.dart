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
        content: Text("${error.message ?? error} Error"),
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

class ProgressDialog extends StatelessWidget {
  const ProgressDialog({
    Key key,
    @required this.status,
  }) : super(key: key);

  final String status;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(width: 5),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(BrandColors.colorAccent),
              ),
              SizedBox(
                width: 25,
              ),
              Text(
                status,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
