import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/sec.dart';
import 'package:flutter_ub/app/helpers/requestHelper.dart';
import 'package:flutter_ub/app/model/Address.dart';
import 'package:flutter_ub/app/model/Prediction.dart';
import 'package:flutter_ub/app/provider/userState.dart';

class SearchPageModel extends ChangeNotifier {
  SearchPageModel(
    this._userState,
  );

  final UserState _userState;

  final pickUpController = TextEditingController();
  final destinationController = TextEditingController();

  var focusDestination = FocusNode();

  List<Prediction> predictionList = [];

  void setFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(focusDestination);
  }

  void searchPlace(String placeName) async {
    if (placeName.isNotEmpty) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=${SDKMapKey.iosKey}&sessiontoken=1234567890&components=country:us";

      var response = await RequestHelper.getRequest(url);

      if (response == "fail") {
        print("fail");
        return;
      }

      if (response["status"] == "OK") {
        var prediction = response["predictions"];

        var thisList =
            (prediction as List).map((e) => Prediction.fromJson(e)).toList();

        predictionList = thisList;
        notifyListeners();
      }
    }
  }

  void getPlaceDetails({String placeId, VoidCallback onSuccess}) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${SDKMapKey.iosKey}";

    var response = await RequestHelper.getRequest(url);

    if (response == "fail") {
      print("fail");
      return;
    }

    if (response["status"] == "OK") {
      Address thisPlace = Address.fromJson(response, placeId);

      /// pass Userstatus
      _userState.updateDistinationAddress(thisPlace);
      onSuccess();
    }
  }
}

// Address thisPlace = Address();
// thisPlace.placeName = response["result"]["name"];
// thisPlace.placeId = placeId;
// thisPlace.latitude = response["result"]["geometry"]["location"]["lat"];
// thisPlace.longtude = response["result"]["geometry"]["location"]["lng"];
