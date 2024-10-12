import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'irrigation_data.dart'; // Assuming this contains your data model
import 'firestore_service.dart'; // Assuming this contains your Firestore logic

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Irrigation History',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: IrrigationHistory(),
    );
  }
}

class IrrigationHistory extends StatefulWidget {
  const IrrigationHistory({super.key});

  @override
  State<IrrigationHistory> createState() => _IrrigationHistoryState();
}

class _IrrigationHistoryState extends State<IrrigationHistory> {
  Future<List<IrrigationData>>? irrigationDataList;

  @override
  void initState() {
    super.initState();
    FirestoreService firestoreService = FirestoreService();
    irrigationDataList = firestoreService.fetchLatestIrrigationData_n(10); // Fetch latest 10 records
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Irrigation Data Chart')),
      body: FutureBuilder<List<IrrigationData>>(
        future: irrigationDataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found"));
          } else {
            var data = snapshot.data!;
            data = data.reversed.toList(); // Reverse the list to get latest data
            return SingleChildScrollView(
              child: Column(
                children: [
                  IrrigationLineChart(irrigationData: data),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class IrrigationLineChart extends StatelessWidget {
  final List<IrrigationData> irrigationData;

  const IrrigationLineChart({required this.irrigationData});

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem('Crop Water Requirement', Colors.blue),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildLegend(),
          SizedBox(height: 20), // Space between legend and chart
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: irrigationData
                    .map((data) => data.cropWaterRequirement)
                    .reduce((a, b) => a > b ? a : b) +
                    2,
                minX: 0,
                maxX: irrigationData.length - 1,
                gridData: FlGridData(drawHorizontalLine: true, drawVerticalLine: true), // Show grid lines
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index < 0 || index >= irrigationData.length) return SizedBox.shrink();
                        final String formattedDate = DateFormat('MMM d').format(irrigationData[index].date);
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0, // Adjust space
                          child: Text(formattedDate, style: TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(), // Convert double to int for CWR values
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        );
                      },
                      interval: 2, // Set interval for Y axis labels
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: irrigationData
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value.cropWaterRequirement,
                      ),
                    )
                        .toList(),
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipMargin: 8,
                    tooltipPadding: const EdgeInsets.all(6),
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItems: (touchedSpots) {
                      if (touchedSpots.isEmpty) return [];
                      final index = touchedSpots[0].x.toInt();
                      final String date = DateFormat('MMM d')
                          .format(irrigationData[index].date);
                      return [
                        LineTooltipItem(
                          "CWR:\n ${(irrigationData[index].cropWaterRequirement * 4046.85642).toStringAsFixed(2)} L\n$date",
                          const TextStyle(color: Colors.white),
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Time', // X-axis label
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

