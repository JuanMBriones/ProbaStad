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
                          MaterialPageRoute(
                              builder: (context) => InputDataRoute()),
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
                      onPressed: () {
                        DataSet data = new DataSet(DataInput.dataPoints);
                      },
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
class InputDataRoute extends StatefulWidget {
  @override
  State createState() => new DataInput();
}

class DataInput extends State<InputDataRoute> {
  @override
  static List<double> dataPoints = [];
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

class DataSet {
  List<double> data;
  double mean;
  double median;
  List<double> modes;
  // int range;
  // double variance;
  // double stdDeviation;

  DataSet(List<double> dataPoints) {
    data = dataPoints;
    data.sort();
    mean = data.reduce((a, b) => a + b) / data.length;
    median = getMedian(data);
    // modes = getModes(dataPoints);

    print("mean: $mean\nmedian: $median\n\nsorted list: $data");
  }

  double getMedian(data) {
    if (data.length % 2 == 1) {
      return data[data.length / 2 + 1];
    } else {
      return (data[data.length / 2] + data[data.length / 2 + 1]) / 2;
    }
  }

/*
  List<double> getModes(List<double> dataPoints) {
    List<double> modes = [];
    int maxCount = 0;

    while (dataPoints.length > 0) {
      double num = dataPoints[0];
      int count = 0;
      for (int i = 0; i < dataPoints.length; ++i) {
        if (dataPoints[i] == num) {
          ++count;
          dataPoints.removeAt(i);
          --i;
        }
      }
      if (count > maxCount) {
        maxCount = count;
        modes.clear();
        modes.add(num);
      } else if (count == maxCount) {
        modes.add(num);
      }
    }

    return modes;
  }
  */
}
