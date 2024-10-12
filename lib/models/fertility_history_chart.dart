import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date

class FertilityLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> fertilityData;

  const FertilityLineChart({super.key, required this.fertilityData});

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem('Fertility', Colors.greenAccent),
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
          _buildLegend(),
          SizedBox(height: 20), // Space between legend and chart
          SizedBox(
            height: 180, // Adjusted height to match SoilLineChart
            child: LineChart(
              LineChartData(
                minY: -0.1,
                maxY: 1.1,
                minX: -0.5,
                maxX: fertilityData.length - 0.5,
                gridData: FlGridData(drawHorizontalLine: false),
                titlesData: const FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
                  border: Border(
                    top: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.black),
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: fertilityData
                        .asMap()
                        .entries
                        .map(
                          (entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value['fertility'].toDouble(),
                      ),
                    )
                        .toList(),
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.greenAccent,
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
                      final String date = DateFormat('MMM d').format(fertilityData[index]['time']);
                      return [
                        LineTooltipItem(
                          "Fertility: ${fertilityData[index]['fertility']}\n$date",
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
