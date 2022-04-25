import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {

  final String message;
  final String sender;
  final bool sentByMe;

  MessageTile({this.message, this.sender, this.sentByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(bottom: 60),
      padding: EdgeInsets.only(
        top: 1,
        bottom: 1,
        left: sentByMe ? 45 : 20,
        right: sentByMe ? 20 : 45),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: sentByMe ? EdgeInsets.only(left: 25) : EdgeInsets.only(right: 25),
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
          decoration: BoxDecoration(
          borderRadius: sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18)
          )
          :
          BorderRadius.only(
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(18)
          ),
          color: sentByMe ? Colors.cyan[200] : Colors.grey[300],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(sender.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
            SizedBox(height: 7.0),
            SelectableText(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 16.0, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}