import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestHelper {
  static Future<dynamic> getRequest(String url) async {
    var response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String data = response.body;

        var decoded = jsonDecode(data);
        return decoded;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }
}
