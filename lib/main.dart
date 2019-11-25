import 'package:flutter/material.dart';
import 'dart:math';

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
  static List<double> data;
  static var mean;
  static var median;
  static List<double> modes;
  static double range;
  static double variance;
  static double stdDeviation;

  DataSet(List<double> dataPoints) {
    data = dataPoints;
    data.sort();
    getStats(data);
  }

  void getStats(List<double> data) {
    mean = data.reduce((a, b) => a + b) / data.length;
    median = getMedian(data);
    modes = getModes(data);
    range = data[data.length - 1] - data[0];
    variance = getVariance(data, mean);
    stdDeviation = sqrt(variance);
  }

  double getMedian(data) {
    double half = data.length / 2;
    int med = half.round();
    if (data.length % 2 == 1) {
      return data[med];
    } else {
      return (data[med] + data[med - 1]) / 2;
    }
  }

  List<double> getModes(data) {
    List<double> modes = [];
    List<double> counted = [];
    int maxCount = 0;

    for (int i = 0; i < data.length - 1; ++i) {
      int count = 0;
      double current = data[i];
      for (int j = i + 1; j < data.length; ++j) {
        if (current == data[j] && !counted.contains(current)) {
          ++count;
        }
      }
      if (count > maxCount) {
        maxCount = count;
        modes.clear();
        modes.add(current);
      } else if (count == maxCount) {
        modes.add(current);
      }
      counted.add(current);
    }
    return modes;
  }

  double getVariance(data, mean) {
    double sum = 0;

    for (int i = 0; i < data.length; ++i) {
      sum += pow(data[i] - mean, 2);
    }
    return sum / data.length;
  }
}
