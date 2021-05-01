import 'package:flutter_ub/app/model/NearByDriver.dart';

class FireHepler {
  static List<NearByDriver> nearDrivers = [];

  static void removeFromList(String geoHash) {
    int index = nearDrivers.indexWhere((element) => element.geoHash == geoHash);
    nearDrivers.removeAt(index);
  }

  static void updateNearDriver(NearByDriver driver) {
    int index =
        nearDrivers.indexWhere((element) => element.geoHash == driver.geoHash);

    nearDrivers[index] = driver;
  }
}
