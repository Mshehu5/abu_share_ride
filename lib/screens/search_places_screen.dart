import 'package:abu_share_ride/global/map_key.dart';
import 'package:abu_share_ride/models/predicted_places.dart';
import 'package:abu_share_ride/widgets/places_prediction_tile.dart';
import 'package:flutter/material.dart';

import '../helpers/request_assistant.dart';

class SearchPlaceScreen extends StatefulWidget {
  const SearchPlaceScreen({super.key});

  @override
  State<SearchPlaceScreen> createState() => _SearchPlaceStreamState();
}

class _SearchPlaceStreamState extends State<SearchPlaceScreen> {

  List<PredictedPlaces> placesPredictedList = [];

  findPlaceAutoCompleteSearch(String inputText) async {
    if (inputText.length > 1) {
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey";
      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(
          urlAutoCompleteSearch);
      if (responseAutoCompleteSearch == "Error Occured. Failed. No Response.") {
        return;
      }
      if (responseAutoCompleteSearch["status"] == "OK") {
        var placePredictions = responseAutoCompleteSearch["predictions"];
        var placePredictionsList = (placePredictions as List).map((jsonData) =>
            PredictedPlaces.fromJson(jsonData)).toList();
        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }


    @override
    Widget build(BuildContext context) {
      bool darkTheme = MediaQuery
          .of(context)
          .platformBrightness == Brightness.dark;

      return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: darkTheme ? Colors.black : Colors.white,
              appBar: AppBar(
                backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.lightGreen,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back,
                    color: darkTheme ? Colors.black : Colors.white,),
                ), // GestureDetector
                title: Text(
                  "Search & Set dropoff location",
                  style: TextStyle(
                      color: darkTheme ? Colors.black : Colors.white),
                ),
                elevation: 0.0,
              ),
              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: darkTheme ? Colors.amber.shade400 : Colors
                          .lightGreen,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white54,
                          blurRadius: 8,
                          spreadRadius: 0.5,
                          offset: Offset(
                            0.7,
                            0.7,
                          ),
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.adjust_sharp,
                                  color: Colors.lightGreen,
                                ),
                                SizedBox(height: 18.0,),

                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: TextField(
                                        onChanged: (value) {
                                           findPlaceAutoCompleteSearch(value);
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Search location here...",
                                          fillColor: darkTheme
                                              ? Colors.black
                                              : Colors.white54,
                                          filled: true,
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                            left: 11,
                                            top: 8,
                                            bottom: 8,
                                          ), // I
                                        ),
                                      ),
                                    ) //
                                )
                              ],
                            )
                          ],
                        )
                    ),
                  ),

                  //display place predictions result
                  (placesPredictedList.length > 0)
                      ? Expanded(
                    child: ListView.separated(
                      itemCount: placesPredictedList.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PlacesPredictionTileDesign(
                          predictedPlaces: placesPredictedList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 0,
                          color: darkTheme ? Colors.amber.shade400 : Colors
                              .lightGreen,
                          thickness: 0,
                        ); // Divider
                      },
                    ), // ListView.separated
                  ) : Container(),
                ],
              )
          )


      );
    }
  }