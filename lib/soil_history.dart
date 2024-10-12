import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'firestore_service.dart';
import 'models/fertility_history_chart.dart';
import 'models/gauge_chart.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soil Fertility App',

      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FertilityGraphScreen(),
    );
  }
}

class FertilityGraphScreen extends StatefulWidget {
  @override
  _FertilityGraphScreenState createState() => _FertilityGraphScreenState();
}

class _FertilityGraphScreenState extends State<FertilityGraphScreen> {
  Future<List<Map<String, dynamic>>>? soilData;

  @override
  void initState() {
    super.initState();
    // Fetch the latest 10 records for the graph
    FirestoreService firestoreService = FirestoreService();
    soilData = firestoreService.fetchLatestSoilData_n(10); // Using the new function


  }
  void _showFertilityHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Fertility Gauge Chart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('The black indicator points to the predicted fertility value in the range 0-1.'),
              SizedBox(height: 20),
              Container(
                height: 150,
                width: 235,
                color: Colors.grey[200],
                child: Center(child:Image.asset('assets/images/fertility_gauge.jpg')),
              ),
              SizedBox(height: 20,),

              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: Colors.redAccent, // Color box for red
                  ),
                  SizedBox(width: 10), // Space between color and text
                  Text('Low Fertility (Range: 0-0.33)', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(height: 10), // Space between rows
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: Colors.amber, // Color box for yellow
                  ),
                  SizedBox(width: 10), // Space between color and text
                  Text('Average Fertility (Range: 0.33-0.66)', style: TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(height: 10), // Space between rows
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: Colors.lightGreen, // Color box for green
                  ),
                  SizedBox(width: 10), // Space between color and text
                  Text('High Fertility (Range: 0.66-1)', style: TextStyle(fontSize: 12)),
                ],
              ),


            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  void _showNPKHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('N,P,K Gauge Charts'),
          content:SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('The black indicators point to the obtained Nitrogen(N) or Phosphorus(P) or Potassium(K) value in the respective ranges.'),
                SizedBox(height: 20),
                Container(
                  height: 120,
                  width: 275,
                  color: Colors.grey[200],
                  child: Center(child:Image.asset('assets/images/npk_gauge.jpg')),
                ),
                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Nitrogen (N)", textAlign: TextAlign.start,),
                  ],
                ),
                SizedBox(height: 10,),
                Row(

                  children: [

                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.redAccent, // Color box for red
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Insufficient (Range: 0-50)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.lightGreen, // Color box for yellow
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Satisfactory (Range: 50-150)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.redAccent, // Color box for red
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Excess (Range: >150)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Phosphorus (P)", textAlign: TextAlign.start,),
                  ],
                ),
                SizedBox(height: 10,),
                Row(

                  children: [

                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.redAccent, // Color box for red
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Insufficient (Range: 0-10)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.lightGreen, // Color box for yellow
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Satisfactory (Range: 10-50)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.redAccent, // Color box for red
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Excess (Range: >50)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Potassium (K)", textAlign: TextAlign.start,),
                  ],
                ),
                SizedBox(height: 10,),
                Row(

                  children: [

                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.redAccent, // Color box for red
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Insufficient (Range: 0-80)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.lightGreen, // Color box for yellow
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Satisfactory (Range: 80-250)', style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.redAccent, // Color box for red
                    ),
                    SizedBox(width: 10), // Space between color and text
                    Text('Excess (Range: >250)', style: TextStyle(fontSize: 12)),
                  ],
                ),


              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soil Fertility Analysis'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: soilData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching data"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No data found"));
          } else {
            // Data is available, build the graph
            var data = snapshot.data!;
            data=data.reversed.toList();
            final latestData = data.last;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {

                            _showFertilityHelpDialog(context);
                          },
                          icon: Icon(Icons.info_outline),
                          iconSize: 30,
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.blueGrey.shade200,

                          ),
                        ),
                      ],
                    ),
                    // Add Gauge Charts for each parameter
                    GaugeChart(
                      value: latestData['fertility'], // Example value for fertility chart
                      minValue: 0,
                      maxValue: 1,
                      goodMin: 0.66,
                      goodMax: 1,
                      midMin: 0.33,
                      midMax: 0.66,
                      size:250,//
                    ),
                    const SizedBox(height: 15),
                    const Text('Fertility Level', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {

                            _showNPKHelpDialog(context);
                          },
                          icon: Icon(Icons.info_outline),
                          iconSize: 30,
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.blueGrey.shade200,

                          ),
                        ),
                      ],

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [

                            GaugeChart(value: latestData['N'], minValue: 0, maxValue: 200, goodMin: 50, goodMax: 150, size: 100),
                            const SizedBox(height: 15),
                            Text('Nitrogen (N)', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 5),
                        Column(
                          children:  [

                            GaugeChart(value: latestData['P'], minValue: 0, maxValue: 150, goodMin: 10, goodMax: 50, size: 100),
                            const SizedBox(height: 15),
                            Text('Phosphorus (P)', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(width: 3),
                        Column(
                          children:  [

                            GaugeChart(value: latestData['K'], minValue: 0, maxValue: 300, goodMin: 80, goodMax: 250, size: 100),
                            const SizedBox(height: 15),
                            Text('Potassium (K)', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 50,),


                    //FertilityLineChart(fertilityData: data,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {

                            //_showFertilityHelpDialog(context);
                          },
                          icon: Icon(Icons.info_outline),
                          iconSize: 30,
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.blueGrey.shade200,

                          ),
                        ),
                      ],
                    ),

                    SoilLineChart(soilData: data),
                    const SizedBox(height: 20),
                    NutrientLineChart(
                      nutrientData: data,
                      nutrientKey: 'N',
                      chartTitle: 'Nitrogen (N)',
                      color: Colors.lightBlueAccent,
                      yMax: 230, yMin: 0,
                    ),
                    const SizedBox(height: 30),
                    NutrientLineChart(
                        nutrientData: data,
                        nutrientKey: 'P',
                        chartTitle: 'Phosphorus (P)',
                        color: Colors.pinkAccent,
                        yMax: 30, yMin: 0
                    ),
                    const SizedBox(height: 30),
                    NutrientLineChart(
                        nutrientData: data,
                        nutrientKey: 'K',
                        chartTitle: 'Potassium (K)',
                        color: Colors.deepPurpleAccent,
                        yMax: 330, yMin: 0
                    ),
                    const SizedBox(height: 30),
                    NutrientLineChart(
                      nutrientData: data,
                      nutrientKey: 'fertility',
                      chartTitle: 'Fertility',
                      color: Colors.greenAccent,
                      yMax: 1,
                      yMin: 0,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class SoilLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> soilData;

  SoilLineChart({required this.soilData});

  // Normalizing values between 0 and 1 for graph plotting
  List<FlSpot> getNormalizedSpots(String key) {
    double minValue = soilData.map((e) => e[key].toDouble()).reduce((a, b) => a < b ? a : b);
    double maxValue = soilData.map((e) => e[key].toDouble()).reduce((a, b) => a > b ? a : b);


    return List.generate(
      soilData.length,
          (index) {
        double value = soilData[index][key].toDouble();
        double normalizedValue = (value - minValue) / (maxValue - minValue); // Normalizing data
        return FlSpot(
          index.toDouble(),
          normalizedValue,
        );
      },
    );
  }

  // Create a legend for the chart
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem('Fertility', Colors.greenAccent),
        _legendItem('N', Colors.lightBlueAccent),
        _legendItem('P', Colors.pinkAccent),
        _legendItem('K', Colors.deepPurpleAccent)//Color.fromARGB(255, 252, 207, 3)),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4), // Set the radius for curved edges
          ),
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
          _buildLegend(), // Add the legend here
          SizedBox(height: 20), // Space between legend and chart
          SizedBox(
            height: 180, // Reduced height for the graph
            child: LineChart(
              LineChartData(
                minY: -0.15,
                maxY: 1.1,
                minX: -0.5,
                maxX: 9.5,
                // Remove grid
                gridData: FlGridData(drawHorizontalLine: false),
                // Customize titles
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // Remove left labels
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // Remove top labels
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false), // Remove right labels
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    top: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: getNormalizedSpots('fertility'),
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false), // Show dots on points
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: getNormalizedSpots('N'),
                    isCurved: true,
                    color: Colors.lightBlueAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false), // Show dots on points
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: getNormalizedSpots('P'),
                    isCurved: true,
                    color: Colors.pinkAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false), // Show dots on points
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: getNormalizedSpots('K'),
                    isCurved: true,
                    color: Colors.deepPurpleAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false), // Show dots on points
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                // Configure hover/touch behavior
                lineTouchData: LineTouchData(
                  enabled: true, // Enable touch interactions
                  handleBuiltInTouches: true, // Handles touches (for hover behavior)
                  touchTooltipData: LineTouchTooltipData(
                    tooltipMargin: 8, // Distance of tooltip from the point
                    tooltipPadding: const EdgeInsets.all(6), // Adjust tooltip padding
                    fitInsideHorizontally: true, // Ensure tooltip stays inside graph width
                    fitInsideVertically: true, // Ensure tooltip stays inside graph height
                    getTooltipItems: (touchedSpots){ return [

                      LineTooltipItem("Fertility: ${soilData[touchedSpots[0].x.toInt()]['fertility']}", // Access the values directly in the string
                          const TextStyle(color: Colors.white)),
                      LineTooltipItem("N: ${soilData[touchedSpots[0].x.toInt()]['N']}" , // Display the attribute name and original value for each touched spot
                          const TextStyle(color:Colors.white)),
                      LineTooltipItem("P: ${soilData[touchedSpots[0].x.toInt()]['P']}" , // Display the attribute name and original value for each touched spot
                          const TextStyle(color:Colors.white)),
                      LineTooltipItem("K: ${soilData[touchedSpots[0].x.toInt()]['K']}\n${DateFormat('MMM d').format(soilData[touchedSpots[0].x.toInt()]['time'])}", // Display the attribute name and original value for each touched spot
                          const TextStyle(color:Colors.white)),

                    ];
                    }
                    ,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10), // Space between the graph and the text
          Text(
            'Time', // Text label below the graph
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


class NutrientLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> nutrientData;
  final String nutrientKey;
  final String chartTitle;
  final Color color;
  final double yMax;
  final double yMin;

  const NutrientLineChart({
    super.key,
    required this.nutrientData,
    required this.nutrientKey,
    required this.chartTitle,
    required this.color,
    required this.yMax,
    required this.yMin,
  });

  @override
  Widget build(BuildContext context) {
    double yInterval = (yMax - yMin) / 10; // Calculate the interval

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chartTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: yMin,
              maxY: yMax,
              minX: -0.5,
              maxX: nutrientData.length - 0.5,
              gridData: FlGridData(
                drawHorizontalLine: false,
                horizontalInterval: yInterval, // Use the calculated interval
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.5),
                    strokeWidth: 1,
                  );
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= nutrientData.length) {
                        return const SizedBox.shrink();
                      }
                      final String date = DateFormat('MMM d').format(nutrientData[index]['time']);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          date,
                          style: const TextStyle(color: Colors.black, fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: yInterval, // Use the calculated interval for the Y-axis labels
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.black, fontSize: 10),
                      );
                    },
                    reservedSize: 32,
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  top: BorderSide(color: Colors.white),
                  right: BorderSide(color: Colors.white),
                  left: BorderSide(color: Colors.black),
                  bottom: BorderSide(color: Colors.black),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: nutrientData.asMap().entries.map(
                        (entry) => FlSpot(
                      entry.key.toDouble(),
                      entry.value[nutrientKey].toDouble(),
                    ),
                  ).toList(),
                  isCurved: true,
                  barWidth: 3,
                  color: color,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipMargin: 8,
                  tooltipPadding: const EdgeInsets.all(6),
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (touchedSpots) {
                    if (touchedSpots.isEmpty) return [];
                    final index = touchedSpots[0].x.toInt();
                    final String date = DateFormat('MMM d').format(nutrientData[index]['time']);
                    return [
                      LineTooltipItem(
                        "$chartTitle: ${nutrientData[index][nutrientKey]}\n$date",
                        const TextStyle(color: Colors.white),
                      ),
                    ];
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

