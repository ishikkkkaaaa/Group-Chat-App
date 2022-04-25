import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/group_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/ui/loading.dart';
import 'package:group_chat_app/ui/custom_button.dart';

class Login extends StatefulWidget {
  static const String id = "LOGIN";
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));

      await _auth
          .signInWithEmailAndPassword(email, password)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseService().getUserData(email);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data['fullName']);

          print("Signed In");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => GroupPage()));
        } else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            body: Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            child: Image.asset(
                              "assets/images/blue_circle.jpg",
                              height: 150,
                              width: 150,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*Expanded(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      "assets/images/blue_circle.jpg",
                      height: 150,
                      width: 150,
                    ),
                  ),
                ),
              ),*/
                  SizedBox(
                    height: 0.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Welcome Back",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 30.0),
                      Text("Login",
                          style:
                              TextStyle(color: Colors.black, fontSize: 25.0)),
                      SizedBox(height: 20.0),
                      TextFormField(
                        //style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          hintText: "Enter Your Email...",
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(18.0),
                        ),
                        //decoration: textInputDecoration.copyWith(labelText: 'Email'),
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Please enter a valid email";
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter Your Password",
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(18.0),
                        ),
                        //decoration: textInputDecoration.copyWith(labelText: 'Password'),
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      CustomButton(
                        text: "Login",
                        callback: () async {
                          await _onSignIn();
                        },
                      ),
                      SizedBox(height: 10.0),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Register here',
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
            ),
          ));
  }
}
