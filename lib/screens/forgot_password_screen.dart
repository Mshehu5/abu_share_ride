import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/screens/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailTextEditingController = TextEditingController();

  // global Key for Form
  final _formkey = GlobalKey<FormState>();

  void _submit() {
    firebaseAuth
        .sendPasswordResetEmail(email: emailTextEditingController.text.trim())
        .then((value) {
      Fluttertoast.showToast(
          msg: "We have sent an email to recover password, please check email");
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "error Occured: \n ${error.toString()}");
    });
  }

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
                  'Reset Password ',
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
                                  // Email Feild

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

                                  // Email Feild End

                                  SizedBox(
                                    height: 20,
                                  ),
                                  // Password Feild  Start
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
                                        'Reset Password',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {},
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
                                        "Already have an account ?",
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (c) =>
                                                      LoginScreen()));
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
