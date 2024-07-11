import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'classroom.dart';
import 'profile.dart';
import 'submissions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins-Regular',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(),
        ),
      ),
      home: const StudentMainScreen(),
    );
  }
}

class StudentMainScreen extends StatelessWidget {
  const StudentMainScreen({super.key});

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
              title: const Text('Classrooms'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClassroomScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Submissions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubmissionsScreen()),
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
      body: const BarGraph(),
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
            'EIE Performance Overview',
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
              width: 1500, // Increase width to accommodate all months
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
                  charts.ChartTitle('Performance',
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea),
                ],
                primaryMeasureAxis: charts.NumericAxisSpec(
                  tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                        (num? value) => value != null ? value.toStringAsFixed(1) : '',
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

    // Generate random data for each month and category (legend)
    for (var month in months) {
      beginningData.add(GrowthData(month, (Random().nextDouble() * 4).toDouble()));
      developingData.add(GrowthData(month, (Random().nextDouble() * 4).toDouble()));
      approachingData.add(GrowthData(month, (Random().nextDouble() * 4).toDouble()));
      proficientData.add(GrowthData(month, (Random().nextDouble() * 4).toDouble()));
    }

    return [
      charts.Series<GrowthData, String>(
        id: 'Beginning',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: beginningData,
        displayName: 'Beginning',
      ),
      charts.Series<GrowthData, String>(
        id: 'Developing',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: developingData,
        displayName: 'Developing',
      ),
      charts.Series<GrowthData, String>(
        id: 'Approaching',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: approachingData,
        displayName: 'Approaching',
      ),
      charts.Series<GrowthData, String>(
        id: 'Proficient',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GrowthData growthData, _) => growthData.month,
        measureFn: (GrowthData growthData, _) => growthData.value,
        data: proficientData,
        displayName: 'Proficient',
      ),
    ];
  }
}
