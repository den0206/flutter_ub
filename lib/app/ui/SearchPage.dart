import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/model/Address.dart';
import 'package:flutter_ub/app/provider/SearchPageModel.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchPageModel>(
      create: (context) => SearchPageModel(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Consumer<SearchPageModel>(
                builder: (context, model, child) {
                  Address currentAdress =
                      Provider.of<UserState>(context).pickupAddress;
                  model.pickUpController.text = currentAdress.placeName;
                  model.setFocus(context);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 40),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.arrow_back),
                            ),
                            Center(
                              child: Text(
                                "Set Destination",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: "Brand-Bold"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        SearchTextField(
                          controller: model.pickUpController,
                          iconPath: "images/pickicon.png",
                          hintText: "Place Location",
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        SearchTextField(
                          focus: model.focusDestination,
                          controller: model.destinationController,
                          iconPath: "images/desticon.png",
                          hintText: "Where To?",
                          onChange: (value) {
                            model.searchPlace(value);
                          },
                        ),
                        Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    Key key,
    this.controller,
    this.focus,
    @required this.iconPath,
    @required this.hintText,
    this.onChange,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focus;
  final String iconPath;
  final String hintText;
  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          height: 16,
          width: 16,
        ),
        SizedBox(
          width: 18,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: BrandColors.colorLightGrayFair,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              focusNode: focus,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                fillColor: BrandColors.colorLightGrayFair,
                filled: true,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.only(
                  left: 8,
                  top: 10,
                  bottom: 10,
                ),
              ),
              onChanged: (value) => onChange(value),
            ),
          ),
        )
      ],
    );
  }
}
