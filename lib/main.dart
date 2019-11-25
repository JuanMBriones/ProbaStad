import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProbaStad',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'ProbaStad Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        padding: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(5),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text("Input Data Set"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DataInput()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(5),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text("Analyze Data"),
                      onPressed: () => null,
                    ),
                  ),
                ),
                Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(5),
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text("Create Graph"),
                      onPressed: () => null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//Data Input ↓
class DataInput extends StatefulWidget {
  @override
  State createState() => new DynamicList();
}

class DynamicList extends State<DataInput> {
  @override
  List<double> dataPoints = [];
  final TextEditingController eCtrl = new TextEditingController();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Input Data Set"),
      ),
      body: new Column(
        children: <Widget>[
          new TextField(
            controller: eCtrl,
            keyboardType: TextInputType.number,
            onSubmitted: (text) {
              double dPoint = double.parse(text);
              dataPoints.add(dPoint);
              eCtrl.clear();
              setState(() {});
            },
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: dataPoints.length,
              itemBuilder: (BuildContext ctxt, int Index) {
                return new Text(dataPoints[Index].toString());
              },
            ),
          )
        ],
      ),
    );
  }
}
