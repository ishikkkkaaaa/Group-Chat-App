import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/group_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/ui/clipper.dart';

import 'announcement_page.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  final String email;
  final AuthService _auth = AuthService();

  ProfilePage({this.userName, this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //shape: CustomShapeBorder(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(10),
            right: Radius.circular(10),
          ),
        ),
        title: Text('Profile',
            style: TextStyle(
                color: Colors.white,
                fontSize: 27.0,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        elevation: 20.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          children: <Widget>[
            /*
            ClipPath(
              clipper: DrawerClipper(),
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent[400],
                ),
              ),
            ),
            */
            Icon(Icons.account_circle, size: 150.0, color: Colors.grey[600]),
            SizedBox(height: 15.0),
            Text("Hello $userName",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 7.0),
            ListTile(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => GroupPage()));
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              title: Text('Groups'),
            ),
            Divider(height: 0.0),
            ListTile(
              selected: true,
              onTap: () {},
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QueryPage(),
                  ),
                );
              },
              selected: false,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.group),
              title: Text('Ask Queries', style: TextStyle(fontSize: 16)),
            ),
            Divider(height: 0.0),
            Divider(height: 0.0),
            ListTile(
              onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthenticatePage()),
                    (Route<dynamic> route) => false);
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
            ClipPath(
              clipper: FooterWaveClipper(),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 170.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.account_circle,
                    size: 200.0, color: Colors.grey[600]),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.account_circle, color: Colors.blue[700]),
                    Text('Full Name', style: TextStyle(fontSize: 17.0)),
                    Text(userName, style: TextStyle(fontSize: 17.0)),
                  ],
                ),
                Divider(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.email, color: Colors.blue[700]),
                    Text('Email', style: TextStyle(fontSize: 17.0)),
                    Text(email, style: TextStyle(fontSize: 17.0)),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
