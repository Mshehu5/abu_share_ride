import 'dart:convert';

import 'package:http/http.dart' as http;


class RequestAssistant {
  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

  try {

    if (httpResponse.statusCode == 200) // successful
        {
      String responseData = httpResponse.body;
      var decodeResponseData = jsonDecode(responseData);

      return decodeResponseData;

    }
    else {
      throw Exception('Error: Failed to fetch data. Status code: ${httpResponse.statusCode}');
    }
  } catch (error){
    throw Exception('Error fetching data: $error');

  }

  }
}