import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/sec.dart';
import 'package:flutter_ub/app/helpers/requestHelper.dart';
import 'package:flutter_ub/app/model/Prediction.dart';

class SearchPageModel extends ChangeNotifier {
  final pickUpController = TextEditingController();
  final destinationController = TextEditingController();

  var focusDestination = FocusNode();

  void setFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(focusDestination);
  }

  void searchPlace(String placeName) async {
    if (placeName.isNotEmpty) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${SDKMapKey.iosKey}&sessiontoken=1234567890&components=country:ng";

      var response = await RequestHelper.getRequest(url);

      if (response == "fail") {
        print("fail");
        return;
      }

      if (response["status"] == "OK") {
        var prediction = response["predictions"];

        var thisList =
            (prediction as List).map((e) => Prediction.fromJson(e)).toList();

        print(thisList.length);
      }
    }
  }
}
