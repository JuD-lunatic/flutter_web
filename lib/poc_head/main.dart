import 'package:flutter/material.dart';
import 'assign_subject.dart';
import 'profile.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: POCHeadMainScreen(),
    );
  }
}

class POCHeadMainScreen extends StatelessWidget {
  const POCHeadMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'icons/eiems-logo.png',
                    height: 40.0,
                  ),
                  const SizedBox(width: 15.0),
                  const Text(
                    'EIEMS',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF383838),
                      fontFamily: 'KronaOne',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_rounded),
              title: const Text('Implementing Subjects'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AssignSubjectScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6CBCFB),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontFamily: 'KronaOne',
          ),
        ),
        elevation: 20.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16.0),
        child: const BarGraph(),
      ),
    );
  }
}

class GrowthData {
  final String month;
  final double value;

  GrowthData(this.month, this.value);
}

class BarGraph extends StatefulWidget {
  const BarGraph({super.key});

  @override
  _BarGraphState createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  late List<charts.Series<GrowthData, String>> _seriesList;

  @override
  void initState() {
    super.initState();
    _seriesList = _createSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Computer Studies Completion Rate Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1500,
              child: charts.BarChart(
                _seriesList,
                animate: true,
                domainAxis: charts.OrdinalAxisSpec(
                  viewport: charts.OrdinalViewport('Aug', 5),
                ),
                defaultRenderer: charts.BarRendererConfig(
                  cornerStrategy: const charts.ConstCornerStrategy(4),
                ),
                behaviors: [
                  charts.SeriesLegend(),
                  charts.ChartTitle('Month',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
                  charts.ChartTitle('Completion Rate',
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                        (num? value) =>
                    value != null
                        ? '${value.toInt()}%'
                        : '',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<charts.Series<GrowthData, String>> _createSampleData() {
    List<String> months = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    List<GrowthData> beginningData = [];
    List<GrowthData> developingData = [];
    List<GrowthData> approachingData = [];
    List<GrowthData> proficientData = [];

    for (var month in months) {
      beginningData.add(GrowthData(month, (Random().nextDouble() * 100)));
      developingData.add(GrowthData(month, (Random().nextDouble() * 100)));
      approachingData.add(GrowthData(month, (Random().nextDouble() * 100)));
      proficientData.add(GrowthData(month, (Random().nextDouble() * 100)));
    }

    return [
      charts.Series<GrowthData, String>(
        id: 'BSIT',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: beginningData,
        displayName: 'BSIT',
      ),
      charts.Series<GrowthData, String>(
        id: 'BSCS',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: developingData,
        displayName: 'BSCS',
      ),
      charts.Series<GrowthData, String>(
        id: 'BLIS',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: approachingData,
        displayName: 'BLIS',
      ),
      charts.Series<GrowthData, String>(
        id: 'ACT',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: proficientData,
        displayName: 'ACT',
      ),
    ];
  }
}
