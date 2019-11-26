import 'package:flutter/material.dart';
import 'dart:math';

import 'package:rflutter_alert/rflutter_alert.dart';

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
  DataSet data; //Se declara aquí para poder pasarla

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
                      onPressed: () => goToAnalyze(),
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
            Container(
              margin: new EdgeInsets.only(top: 300.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: new Container(
                      margin: EdgeInsets.all(5),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Text("Delete Data Set"),
                        onPressed: () {
                          DataInput.dataPoints.clear();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void goToAnalyze() {
    if (DataInput.dataPoints.length > 0) {
      data = DataSet(); //Se inicializa porque hay datos para trabajar
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnalyzeDataRoute(
                  data: data,
                )),
      );
    } else {
      //Si no hay suficientes, manda un warning y no permite cambiar de pantalla
      Alert(
              context: context,
              title: "Data Set Empty",
              desc: "Please input a Data Set in the \"Input Data Set\" section")
          .show();
    }
  }
}

//Data Input ↓
class InputDataRoute extends StatefulWidget {
  @override
  State createState() => new DataInput();
}

class DataInput extends State<InputDataRoute> {
  @override
  static List<double> dataPoints =
      []; //Se declara estática porque sólo hay un data set
  final TextEditingController eCtrl = new TextEditingController();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Input Data Set"),
      ),
      body: new Container(
        padding: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: new TextField(
                decoration: InputDecoration(hintText: "Insert data point here"),
                controller: eCtrl,
                keyboardType: TextInputType.number,
                onSubmitted: (text) {
                  double dPoint = double.parse(text);
                  dataPoints.add(dPoint);
                  eCtrl.clear();
                  setState(() {});
                },
              ),
              decoration: BoxDecoration(
                  border: new Border.all(
                color: Colors.purple,
                width: 3,
              )),
            ),
            new Expanded(
              child: new ListView.builder(
                itemCount: dataPoints.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  return new Dismissible(
                    child: Container(
                      padding: new EdgeInsets.symmetric(vertical: 0.0),
                      decoration: BoxDecoration(
                        border: new Border(
                          bottom: new BorderSide(
                              color: Colors.black,
                              width: 1.5,
                              style: BorderStyle.solid),
                        ),
                      ),
                      child: ListTile(
                          title: new Text(dataPoints[Index].toString()),
                          trailing: new Icon(Icons.delete_sweep)),
                    ),
                    key: new Key(dataPoints[Index].toString()),
                    onDismissed: (direction) {
                      dataPoints.removeAt(Index);
                    },
                    background: new Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Analyze Data ↓
class AnalyzeDataRoute extends StatefulWidget {
  final DataSet data; //Se declara aquí para pasarlo

  AnalyzeDataRoute(
      {this.data}); //Se declara un constructor con parametro nombrado data de tipo DataSet

  // @override
  State createState() => new DataAnalysis(
      data: this.data); //Se pasa el DataSet con el constructor del estado
}

class DataAnalysis extends State<AnalyzeDataRoute> {
  final DataSet
      data; //Se declara para que sepa que DataAnalysis tiene un DataSet

  DataAnalysis({this.data}); //Constructor

  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analyze Data"),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 5,
              margin: new EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(data.printThings())
                ], //Gracias a todo ese rodeo de "this.data" podemos acceder a los datos en esta clase que es hijo del hijo del hijo del hijo
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataSet {
  //Propiedades estadísticas de un DataSet
  List<double> data = DataInput.dataPoints;
  double mean;
  double median;
  List<double> modes;
  double range;
  double variance;
  double stdDeviation;

  DataSet() {
    getStats(data); //Nomás para que esté la función getStats()
  }

  void getStats(List<double> dataPoints) {
    data = dataPoints;
    data.sort();
    mean = getMean(data);
    median = getMedian(data);
    modes = getModes(data);
    range = data[data.length - 1] - data[0];
    variance = getVariance(data, mean);
    stdDeviation = sqrt(variance);
  }

  double getMean(data) {
    if (data.length == 1) {
      return data[0];
    }
    double sum = 0;
    for (int i = 0; i < data.length; ++i) {
      sum += data[i];
    }

    return sum / data.length;
  }

  double getMedian(data) {
    if (data.length == 1) {
      return data[0];
    }
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
    if (data.length == 1) {
      modes.add(data[0]);
      return modes;
    }
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

  String printThings() {
    //Debugging a la antiguita
    return "mean: $mean\nmedian: $median\nmodes: $modes\nordered list: $data\nvariance: $variance\nstd deviation: $stdDeviation";
  }
}

class Grapher {
  //Falta Grapher
}
