import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';

// ignore: must_be_immutable
class ConfirmSheet extends StatelessWidget {
  ConfirmSheet({
    Key key,
    @required this.isOnline,
    @required this.cancelAction,
    @required this.confirmAction,
  }) : super(key: key);

  bool isOnline;
  final Function() cancelAction;
  final Function() confirmAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: kBoxDecoration,
        height: 220,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              isOnline ? "Go OFFLine" : "Go Online",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Brand-Bold",
                color: BrandColors.colorText,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "about To online",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Brand-Bold",
                color: BrandColors.colorTextLight,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  width: 150,
                  title: "Cancel",
                  backColor: Colors.white,
                  titleColor: Colors.black,
                  onPressed: () {
                    cancelAction();
                  },
                ),
                CustomButton(
                  width: 150,
                  title: isOnline ? "Back OFFLine" : "Go Online",
                  backColor: isOnline ? Colors.blue : Colors.red,
                  titleColor: Colors.white,
                  onPressed: () {
                    confirmAction();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
