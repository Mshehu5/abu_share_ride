// import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../helpers/dio_exceptions.dart';

String baseUrl = 'https://api.mapbox.com/geocoding/v5/mapbox.places';
String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;

Dio _dio = Dio();

Future<Map<String, dynamic>> getReverseGeocodingGivenLatLngUsingMapbox(
    LatLng latLng) async {
  String query = '${latLng.longitude},${latLng.latitude}';
  String url = '$baseUrl/$query.json?access_token=$accessToken';
  url = Uri.parse(url).toString();
  print(url);
  try {
    _dio.options.contentType = Headers.jsonContentType;
    final responseData = await _dio.get(url);
    print(responseData.data);

    // print("------");
    // String jsonString = json.encode(responseData.data);
    // print(jsonString);
    return responseData.data;
  } catch (e) {
    final errorMessage = DioExceptions.fromDioError(e as DioError).toString();
    debugPrint(errorMessage);
    throw "erroe found";
  }
}
