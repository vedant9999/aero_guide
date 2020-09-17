import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:flutterchatbot/message.dart';

void main() => runApp(MaterialApp(
  home: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final List<FactsMessage> _message = <FactsMessage>[];
  final TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget _query(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
        child: Row(
          children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration.collapsed(hintText: "send"),
                )
              ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              
              icon: Icon(Icons.send),
              onPressed: (){
                _submitquery(_textEditingController.text);
              },
            ),
          )
          ],

        ),
    );
  }

  void _submitquery(String text) {
    _textEditingController.clear();
    FactsMessage message = FactsMessage(
      text: text,
      type: true
    );


    setState(() {
      _message.insert(0, message);
    });
   dialog_flow_response(text);
  }

  Future dialog_flow_response(String query) async {
    _textEditingController.clear();
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/chatbot2.json").build();
    Dialogflow dialogflow = Dialogflow( authGoogle: authGoogle,language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    print(response.getListMessage());
    FactsMessage message = FactsMessage(
      text: response.getMessage() ?? CardDialogflow(response.getListMessage()[0]).title,
      type: false,
    );
    setState(() {
      _message.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("DEMO"),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _message.length,
                itemBuilder: (_,int index) => _message[index]),
          ),
          Divider(height: 1.0,),
          Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _query(context),
          )
        ],
      ),
    );
  }
}
