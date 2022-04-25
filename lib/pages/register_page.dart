import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/group_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/ui/loading.dart';
import 'package:group_chat_app/ui/custom_button.dart';

class RegisterPage extends StatefulWidget {
  static const String id = "REGISTRATION";
  final Function toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .registerWithEmailAndPassword(fullName, email, password)
          .then((result) async {
        if (result != null) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(fullName);

          print("Registered");
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
            error = 'Error while registering the user!';
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
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
                      SizedBox(
                        height: 0.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Create or Join Groups",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 30.0),
                          Text("Register",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 25.0)),
                          SizedBox(height: 20.0),
                          TextFormField(
                            style: TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: "Enter Your Name...",
                              border: const OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(18.0),
                            ),
                            //decoration: textInputDecoration.copyWith(labelText: 'Full Name'),
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                          ),
                          SizedBox(height: 15.0),
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
                            validator: (val) => val.length < 6
                                ? 'Password not strong enough'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          SizedBox(height: 20.0),
                          CustomButton(
                            text: "Register",
                            callback: () async {
                              await _onRegister();
                            },
                          ),
                          SizedBox(height: 10.0),
                          Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14.0),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Sign In',
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
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0)),
                        ],
                      ),
                    ],
                  ),
                )),
          );
  }
}
