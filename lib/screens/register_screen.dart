import 'package:abu_share_ride/screens/main_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:abu_share_ride/global/global.dart';

import 'forgot_password_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

//Feilds Controllers for form

class _RegisterScreenState extends State<RegisterScreen> {
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  // global Key for Form

  final _formkey = GlobalKey<FormState>();

//Function to validate all the form fields

  // void _submit() async {
  //   if (_formkey.currentState!.validate()) {
  //     await firebaseAuth
  //         .createUserWithEmailAndPassword(
  //             email: emailTextEditingController.text.trim(),
  //             password: passwordTextEditingController.text.trim())
  //         .then((auth) async {
  //       if (currentUser != null) {
  //         Map userMap = {
  //           "id": currentUser!.uid,
  //           "name": nameTextEditingController.text.trim(),
  //           "email": emailTextEditingController.text.trim(),
  //           "address": addressTextEditingController.text.trim(),
  //           "phone": phoneTextEditingController.text.trim(),
  //         };
  //         DatabaseReference userRef =
  //             FirebaseDatabase.instance.ref().child("users");
  //         userRef.child(currentUser!.uid).set(userMap);
  //       }
  //       await Fluttertoast.showToast(msg: "Successfully Registered");
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (c) => MainScreen()));
  //     }).catchError((errorMessage) {
  //       Fluttertoast.showToast(msg: "Error o ccured: \n $errorMessage");
  //     });
  //   } else {
  //     Fluttertoast.showToast(msg: "Not all fields are valid");
  //   }
  // }

  void _submit() async {
    if (_formkey.currentState!.validate()) {
      try {
        // Create user with Firebase Authentication
        UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim());

        // Check if user creation was successful
        if (userCredential != null) {
          User? currentUser = userCredential.user;

          // Prepare user data map with proper handling of null values
          Map<String, String> userMap = {
            "id": currentUser?.uid ?? "", // Use null-safe operator for 'uid'
            "name": nameTextEditingController.text.trim(),
            "email": emailTextEditingController.text.trim(),
            "address": addressTextEditingController.text.trim(),
            "phone": phoneTextEditingController.text.trim(),
          };

          // Create a reference to the "drivers" node in the database
          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("userz").child(currentUser!.uid);

          // Save user data to Firebase Realtime Database
          await userRef.set(userMap);

          // Display success message
          Fluttertoast.showToast(msg: "Successfully Registered");

          // Navigate to MainScreen
          Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
        }
      } on FirebaseAuthException catch (e) {
        // Handle Firebase Authentication errors
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(msg: 'The email address is already in use by another account.');
        } else {
          Fluttertoast.showToast(msg: 'Registration failed: ${e.message}');
        }
      } catch (e) {
        // Handle other potential errors (e.g., network issues)
        Fluttertoast.showToast(msg: 'An unexpected error occurred:');
      }
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

// UI elements for register page
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Column(
              children: [
                // Image.asset(darkTheme ? 'images/city.jpg' : 'images/city.jpg'),
                SizedBox(height: 20),
                Text(
                  'Register',
                  style: TextStyle(
                      color:
                          darkTheme ? Colors.amber.shade400 : Colors.lightGreen,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                              key: _formkey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Name Feild
                                  TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50)
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme
                                            ? Colors.black45
                                            : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.lightGreen,
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Name can\'t be empty';
                                        }
                                        if (text.length < 2) {
                                          return "Please enter a valid name";
                                        }
                                        if (text.length > 49) {
                                          return 'Name can\'t be more than 50';
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                            nameTextEditingController.text =
                                                text;
                                          })),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(100)
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme
                                            ? Colors.black45
                                            : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.lightGreen,
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Email can\'t be empty';
                                        }
                                        if (EmailValidator.validate(text) ==
                                            true) {
                                          return null;
                                        }
                                        if (text.length < 2) {
                                          return "Please enter a valid Email";
                                        }
                                        if (text.length > 99) {
                                          return 'Email can\'t be more than 100';
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                            emailTextEditingController.text =
                                                text;
                                          })),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  IntlPhoneField(
                                    showCountryFlag: false,
                                    dropdownIcon: Icon(Icons.arrow_drop_down,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.lightGreen),
                                    decoration: InputDecoration(
                                      hintText: "Phone Number",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: darkTheme
                                          ? Colors.black45
                                          : Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          )),
                                    ),
                                    initialCountryCode: '+234',
                                    onChanged: (text) => setState(() {
                                      phoneTextEditingController.text =
                                          text.completeNumber;
                                    }),
                                  ),
                                  TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(100)
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "Address",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme
                                            ? Colors.black45
                                            : Colors.grey.shade200,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            )),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.lightGreen,
                                        ),
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Address can\'t be empty';
                                        }
                                        if (text.length < 2) {
                                          return "Please enter a valid Address";
                                        }
                                        if (text.length > 99) {
                                          return 'Address can\'t be more than 100';
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                            addressTextEditingController.text =
                                                text;
                                          })),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      obscureText: !_passwordVisible,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(100)
                                      ],
                                      decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: darkTheme
                                              ? Colors.black45
                                              : Colors.grey.shade200,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              )),
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: darkTheme
                                                ? Colors.amber.shade400
                                                : Colors.lightGreen,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: darkTheme
                                                  ? Colors.amber.shade400
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              // update the state i.e toggle the state pf password Visible variable
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          )),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Password can\'t be empty';
                                        }
                                        if (EmailValidator.validate(text) ==
                                            true) {
                                          return null;
                                        }
                                        if (text.length < 6) {
                                          return "Please enter a valid password";
                                        }
                                        if (text.length > 49) {
                                          return 'Password can\'t be more than 49';
                                        }
                                        return null;
                                      },
                                      onChanged: (text) => setState(() {
                                            passwordTextEditingController.text =
                                                text;
                                          })),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                      obscureText: !_passwordVisible,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(100)
                                      ],
                                      decoration: InputDecoration(
                                          hintText: "Confirm Password",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          filled: true,
                                          fillColor: darkTheme
                                              ? Colors.black45
                                              : Colors.grey.shade200,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              )),
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: darkTheme
                                                ? Colors.amber.shade400
                                                : Colors.lightGreen,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: darkTheme
                                                  ? Colors.amber.shade400
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              // update the state i.e toggle the state pf password Visible variable
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          )),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Confirm Password can\'t be empty';
                                        }
                                        if ((text !=
                                            passwordTextEditingController
                                                .text)) {
                                          return "Password do not match";
                                        }
                                        if (text.length < 6) {
                                          return "Please enter a valid password";
                                        }
                                        if (text.length > 49) {
                                          return 'Password can\'t be more than 49';
                                        }
                                        return null;
                                      },
                                      onChanged: (text) => setState(() {
                                            confirmTextEditingController.text =
                                                text;
                                          })),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.lightGreen,
                                          foregroundColor: darkTheme
                                              ? Colors.black
                                              : Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          minimumSize:
                                              Size(double.infinity, 50)),
                                      onPressed: () {
                                        _submit();
                                      },
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) =>
                                                  ForgotPasswordScreen()));
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.lightGreen),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Have an account?",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                                        },
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: darkTheme
                                                  ? Colors.amber.shade400
                                                  : Colors.lightGreen),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
