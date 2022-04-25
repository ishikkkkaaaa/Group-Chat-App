import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/login_page.dart';
import 'package:group_chat_app/pages/register_page.dart';
import 'package:group_chat_app/ui/custom_button.dart';
import 'package:group_chat_app/ui/clipper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter ChatApp',
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFFFFFFF)),
      //theme: ThemeData.dark(),
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(),
        RegisterPage.id: (context) => RegisterPage(),
        Login.id: (context) => Login(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  static const String id = "HOMESCREEN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipPath(
            clipper: TopClipper(),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.cyanAccent[400],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  width: 100.0,
                  child: Image.asset("assets/images/blue_circle.jpg"),
                ),
              ),
              Text(
                "Flutter ChatApp",
                style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          // TBA
          CustomButton(
            text: "Log In",
            callback: () {
              Navigator.of(context).pushNamed(Login.id);
            },
          ),
          CustomButton(
            text: "Register",
            callback: () {
              Navigator.of(context).pushNamed(RegisterPage.id);
            },
          ),

          ClipOval(
              clipper: BottomClipper(),
              child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                  ))),
        ],
      ),
    );
  }
}
