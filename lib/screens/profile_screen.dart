import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  DatabaseReference userRef =
  FirebaseDatabase.instance.ref().child("users");

  Future<void> showUserNameDialogAlert(BuildContext context, String name) {

    nameTextEditingController.text = name; // = name  //TODO
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
                  )
                ],
              ), // Column
            ), //
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value) {
                    nameTextEditingController.clear();
                    Fluttertoast.showToast (msg: "Updated Succesfully. In Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast (msg: "Error Occurred. In $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("oK", style: TextStyle(color: Colors.black),),
              ), // TextButton
            ],
          );
        }
    );
  }

  Future<void> showUserPhoneDialogAlert (BuildContext context, String Phone) {

    phoneTextEditingController.text = Phone;   //TODO
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneTextEditingController,
                  )
                ],
              ), // Column
            ), //
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": phoneTextEditingController.text.trim(),
                  }).then((value) {
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast (msg: "Updated Succesfully. In Reload the app to see the changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast (msg: "Error Occurred. In $errorMessage");
                  });
                  Navigator.pop(context);
                },
                child: Text("oK", style: TextStyle(color: Colors.black),),
              ), // TextButton
            ],
          );
        }
    );
  }




  Future<void> showUserAddressDialogAlert (BuildContext context, String address) {

    addressTextEditingController.text = address; // = name  //TODO
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: addressTextEditingController,
                  )
                ],
              ), // Column
            ), //
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": addressTextEditingController.text.trim(),
                  }).then((value) {
                    addressTextEditingController.clear();
                  Fluttertoast.showToast (msg: "Updated Succesfully. In Reload the app to see the changes");
                  }).catchError((errorMessage) {
                  Fluttertoast.showToast (msg: "Error Occurred. In $errorMessage");
          });
                  Navigator.pop(context);
                },
                child: Text("oK", style: TextStyle(color: Colors.black),),
              ), // TextButton
            ],
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),

          ),
          title: Text("Profile Screen", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person,color: Colors.white,),
                ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Text("${
            // TODO
            userModelCurrentInfo!.name
            }",
              style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              ),
            ), // Text
            IconButton(onPressed: () {
              showUserNameDialogAlert(context, userModelCurrentInfo!.name!); //TODO //userModelCurrentinfo!.name!
            },
                icon: Icon(
                  Icons.edit,

                )
            ),
            ],
        ),
                Divider(
                  thickness:1 ,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${
                    // TODO
                    userModelCurrentInfo!.phone
                    }",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ), // Text
                    IconButton(onPressed: () {
                      showUserPhoneDialogAlert(context, userModelCurrentInfo!.phone!); //TODO //userModelCurrentinfo!.phone!
                    },
                        icon: Icon(
                          Icons.edit,

                        )
                    ),
                  ],
                ),

                Divider(
                  thickness:1 ,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${
              // TODO
               userModelCurrentInfo!.address
                  }",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ), // Text
              IconButton(onPressed: () {
                showUserAddressDialogAlert(context, userModelCurrentInfo!.address!); //TODO //userModelCurrentinfo!.address!
              },
                  icon: Icon(
                    Icons.edit,

                  )
              ),
            ],
          ),


                Divider(
                  thickness:1 ,
                ),

                Text("${
                // TODO
                 userModelCurrentInfo!.email}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        )


      ),
    );
  }
}
