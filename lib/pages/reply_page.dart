import 'package:flutter/material.dart';
import 'package:group_chat_app/models/comment.dart';
import 'package:group_chat_app/services/database_service.dart';

class QueryRepliesPage extends StatefulWidget {
  final String postId;
  QueryRepliesPage(this.postId);
  @override
  _QueryReplyPageState createState() => _QueryReplyPageState();
}

class _QueryReplyPageState extends State<QueryRepliesPage> {
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessages() {
    return StreamBuilder<List<Comments>>(
      stream: DatabaseService().getComments(widget.postId),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(snapshot.data[index].sender),
                        subtitle: Text(snapshot.data[index].message),
                      ),
                    ),
                  );
                })
            : Container(
                margin: EdgeInsets.only(bottom: 50),
              );
      },
    );
  }

  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      DatabaseService().comment(
          message: messageEditingController.text, postId: widget.postId);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // DatabaseService().getChats(widget.groupId).then((val) {
    //   // print(val);
    //   setState(() {
    //     _chats = val;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Here are your answers!",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 10.0,
      ),
      body: Container(
        //margin: EdgeInsets.only(bottom:50),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/white_bg_1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              child: _chatMessages(),
              padding: EdgeInsets.only(bottom: 65),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: 3,
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        //scrollPadding: Padding,
                        controller: messageEditingController,
                        //controller: scrollController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          fillColor: Colors.white.withOpacity(0.8),
                          filled: true,
                          hintText: "Send an answer ...",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
