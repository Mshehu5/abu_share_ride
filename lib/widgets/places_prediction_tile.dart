import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/global/map_key.dart';
import 'package:abu_share_ride/helpers/request_assistant.dart';
import 'package:abu_share_ride/models/directions.dart';
import 'package:abu_share_ride/models/predicted_places.dart';
import 'package:abu_share_ride/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../infoHandler/app_info.dart';

class PlacesPredictionTileDesign extends StatefulWidget {

  final PredictedPlaces? predictedPlaces;

  PlacesPredictionTileDesign({this.predictedPlaces});


  State<PlacesPredictionTileDesign> createState() => _PlacesPredictionTileDesignState();
}

class _PlacesPredictionTileDesignState extends State<PlacesPredictionTileDesign> {

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(
              message: "Setting up Drop - off, Please wait....",
            )
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestAssistant.receiveRequest(
        placeDirectionDetailsUrl);

    Navigator.pop((context));

    if (responseApi == "Error Occured, failed. No response.") {
      return;
    }

    if (responseApi["status"] == "OK") {
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =
      responseApi["result"]["geometry"]["location"]["lng"];
      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(
          directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });
      Navigator.pop(context, "obtainedDropoff");
    }
  }


  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return ElevatedButton(
        onPressed: () {
          getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: darkTheme ? Colors.black : Colors.white,
        ),
        child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
        children: [
        Icon(
        Icons.add_location,
        color: darkTheme? Colors.amber.shade400: Colors.lightGreen,
        ), // Icon
        SizedBox(width: 10,),
        Expanded(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
        widget.predictedPlaces!.main_text!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
        fontSize: 16,
        color: darkTheme ? Colors.amber.shade400 : Colors.lightGreen,
        ), // TextStyle
        ),
      Text(
        widget.predictedPlaces!.secondary_text!,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          color: darkTheme ? Colors.amber.shade400: Colors.lightGreen,
        ), // TextStyle
      )
    ],
    ),
    ),
    ],
    ),
    )
    );
  }
}
