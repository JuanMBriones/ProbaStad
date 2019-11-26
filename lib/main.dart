import 'package:flutter/material.dart';
import 'dart:math';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:random_color/random_color.dart';



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
                      onPressed: () => goToGrapher(),
                      /*
                      * onPressed: () {
                          DataInput.dataPoints.clear();
                        },
                      * */
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

      Alert(

          context: context,
          title: "Data Set Empty",
          desc: data.data.toString())
          .show();
    } else {
      //Si no hay suficientes, manda un warning y no permite cambiar de pantalla
      Alert(
              context: context,
              title: "Data Set Empty",
              desc: "Please input a Data Set in the \"Input Data Set\" section")
          .show();
    }
  }

  void goToGrapher() {
    if (DataInput.dataPoints.length > 0) {
      data = DataSet(); //Se inicializa porque hay datos para trabajar
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Grapher(
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
  List<double> data = DataInput.dataPoints; //



  double mean;
  double median;
  List<double> modes;
  double range;
  double variance;
  double stdDeviation;

  DataSet() {
    getStats(data); //Nomás para que esté la función getStats()

    data.sort();
  }

  static Map<double, int> s;
  void Histograma() {


    for(int i=0; i<data.length; i++) {
      if(s.containsKey(data[i])) {
        s[data[i]]++;
      }
      else {
        s[data[i]] = 1;
      }
    }


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

/*class Grapher {
  //Falta Grapher
}*/





class Grapher extends StatefulWidget {
  final Widget child;

  Grapher({Key key, this.child}) : super(key: key);

  _GrapherState createState() => _GrapherState();
}

class _GrapherState extends State<Grapher> {
  List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<Sales, int>> _seriesLineData;


  final _random = new Random();
  int next(int min, int max) => min + _random.nextInt(max - min);

  // next ->

  Color colorRan() {
    int a = next(0, 5);
    if(a==1) {
      return Color(0xff3366cc);
    }
    if(a==2) {
      return Color(0xff990099);
    }
    if(a==3) {
      return Color(0xff109618);
    }
    if(a==4) {
      return Color(0xfffdbe19);
    }
    else {
      return Color(0xffff9900);
    }
  }

  generateData() {
    var data1 = [
      new Pollution(30),
      new Pollution(40),
      new Pollution(10),
    ];


    var piedata = [
      new Task(10, colorRan()),
      new Task(40, colorRan()),
      new Task(30, colorRan()),
    ];

    var linesalesdata = [
      new Sales(0, 10),
      new Sales(10, 30),
      new Sales(30, 40),

    ];


    //RandomColor _randomColor = RandomColor();

    //Color _color = _randomColor.randomColor();

    _seriesData.add(
      charts.Series(
        domainFn: (Pollution pollution, _) => pollution.quantity.toString(),
        measureFn: (Pollution pollution, _) => pollution.quantity,
        id: '2017',
        data: data1,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Pollution pollution, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );


    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.tasks,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<Pollution, String>>();
    _seriesPieData = List<charts.Series<Task, String>>();
    _seriesLineData = List<charts.Series<Sales, int>>();
    generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff1976d2),
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
              ],
            ),
            title: Text('Flutter Charts'),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Data analizer: Bar chart',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
                            //behaviors: [new charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Data analyzed on Pie Chart',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10.0,),
                        Expanded(
                          child: charts.PieChart(
                              _seriesPieData,
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                              behaviors: [
                                new charts.DatumLegend(
                                  outsideJustification: charts.OutsideJustification.endDrawArea,
                                  horizontalFirst: false,
                                  desiredMaxRows: 2,
                                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                                  entryTextStyle: charts.TextStyleSpec(
                                      color: charts.MaterialPalette.purple.shadeDefault,
                                      fontFamily: 'Georgia',
                                      fontSize: 11),
                                )
                              ],
                              defaultRenderer: new charts.ArcRendererConfig(
                                  arcWidth: 100,
                                  arcRendererDecorators: [
                                    new charts.ArcLabelDecorator(
                                        labelPosition: charts.ArcLabelPosition.inside)
                                  ])),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Data on line chart',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.LineChart(
                              _seriesLineData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: true, stacked: true),
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                              behaviors: [
                                new charts.ChartTitle('Years',
                                    behaviorPosition: charts.BehaviorPosition.bottom,
                                    titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Sales',
                                    behaviorPosition: charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts.OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Departments',
                                  behaviorPosition: charts.BehaviorPosition.end,
                                  titleOutsideJustification:charts.OutsideJustification.middleDrawArea,
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Pollution {
  String routlator;
  int quantity;

  Pollution(this.quantity) {
    routlator = quantity.toString();
  }
}

class Task {
  String tasks;
  double taskvalue;
  Color colorval;

  Task(this.taskvalue, this.colorval) {
    //this.task = "ddd";
    tasks =  taskvalue.toString();
  }// fr
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}

