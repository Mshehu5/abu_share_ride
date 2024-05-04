import 'dart:convert';

import 'package:http/http.dart' as http;


class RequestAssistant {
  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

  try {
    if (httpResponse.statusCode == 200) // successful
        {
      String responeData = httpResponse.body;
      var decodeResponseOata = jsonDecode(responeData);

      return decodeResponseOata;

    }
    else {
      return "Error Occuread. Failed No Response";
    }
  } catch (exp){
    return "Error Occured. Failed No Responme";

  }

  }
}