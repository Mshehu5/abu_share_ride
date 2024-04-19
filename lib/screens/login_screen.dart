import 'package:abu_share_ride/global/global.dart';
import 'package:abu_share_ride/screens/forgot_password_screen.dart';
import 'package:abu_share_ride/screens/main_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();

  bool _passwordVisible = false;

  // global Key for Form
  final _formkey = GlobalKey<FormState>();

  void _submit() async {
    if (_formkey.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((auth) async {
        currentUser = auth.user;

        await Fluttertoast.showToast(msg: "Successfully Logged In");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Error occured: \n $errorMessage");
      });
    } else {
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
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
                  'Sign In ',
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
                                    height: 10,
                                  ),
                                  // Password Feild  Start
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
                                  // Password Field End
                                  SizedBox(
                                    height: 10,
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
                                        'Sign In',
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
                                        "Don't have an Account?",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                          "Register",
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
