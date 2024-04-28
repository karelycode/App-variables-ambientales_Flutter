import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Graphic extends StatefulWidget {

Graphic({Key? key}) : super(key: key);

@override
_MyGraphics createState() {
return _MyGraphics();
}
}

class _MyGraphics extends State<Graphic> {

List< _variablesData> data = <_variablesData>[];

@override
void initState() {
getDataFromFireStore().then((results) {
SchedulerBinding.instance!.addPostFrameCallback((String) {
setState(() {});
});
});
super.initState();
}

Future<void> getDataFromFireStore() async {
var snapShotsValue =
await FirebaseFirestore.instance.collection('variablesTH').get();
List<_variablesData> data1 = snapShotsValue.docs
    .map((e) {
return  _variablesData((e.data()['fecha']),(e.data()['temperatura']));
}).toList();
setState(() {
data = data1;
print("**"+data.toString());
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
backgroundColor: Theme.of(context).colorScheme.primary,
title: const Text('Temperaturas'),
),
body: Column(children: [
//Initialize the chart widget
SfCartesianChart(
primaryXAxis: CategoryAxis(),
legend: Legend(isVisible: true),
tooltipBehavior: TooltipBehavior(enable: true),
series: <CartesianSeries<_variablesData, String>>[
LineSeries<_variablesData, String>(
dataSource: data,
xValueMapper: (_variablesData datos, _) {
return datos.year;
},
yValueMapper: (_variablesData datos, _) {
return datos.datos;
},
name: 'Temperatura',
// Enable data label
dataLabelSettings: DataLabelSettings(isVisible: true))
]),
Expanded(
child: data.isEmpty
? Center(
child: Text('No hay datos disponibles'),
)
    : SfSparkLineChart.custom(
trackball: SparkChartTrackball(
activationMode: SparkChartActivationMode.tap,
),
marker: SparkChartMarker(
displayMode: SparkChartMarkerDisplayMode.all,
),
labelDisplayMode: SparkChartLabelDisplayMode.all,
xValueMapper: (int index) {
return data[index].year;
},
yValueMapper: (int index) {
return data[index].datos;
},
dataCount: 5,
),
)
]));
}
}

class _variablesData {
_variablesData(this.year, this.datos);
final String year;
final double datos;
}