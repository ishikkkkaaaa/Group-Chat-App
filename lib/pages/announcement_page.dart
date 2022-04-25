import 'package:flutter/material.dart';
import 'package:group_chat_app/models/announcement.dart';
import 'package:group_chat_app/pages/reply_page.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/ui/custom_button.dart';

class QueryPage extends StatefulWidget {
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  TextEditingController messageEditingController = new TextEditingController();
  TextEditingController titleEditingController = new TextEditingController();

  Widget _chatMessages() {
    return StreamBuilder<List<AskQuery>>(
      stream: DatabaseService().readAllQuery(),
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
                        title: Text(snapshot.data[index].title),
                        subtitle: Text(snapshot.data[index].desc),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QueryRepliesPage(snapshot.data[index].id))),
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
    if (messageEditingController.text.isNotEmpty &&
        titleEditingController.text.isNotEmpty) {
      AskQuery Query = AskQuery(
        title: titleEditingController.text,
        desc: messageEditingController.text,
        timestamp: DateTime.now(),
      );

      DatabaseService().addQuery(Query);

      setState(() {
        messageEditingController.text = "";
        titleEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Queries",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 10.0,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Create Query",
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: TextField(
                            controller: titleEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.8),
                              filled: true,
                              hintText: "Your name",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.white.withOpacity(0.8),
                              filled: true,
                              hintText: "Ask your question",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                            ),
                          ),
                        ),
                        CustomButton(
                          text: 'Send',
                          callback: () {
                            _sendMessage();
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
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
          ],
        ),
      ),
    );
  }
}
