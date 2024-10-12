import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Agriculture App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agriculture App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FertilityGaugePage()),
            );
          },
          child: const Text('Go to Fertility and NPK Charts'),
        ),
      ),
    );
  }
}

// Fertility gauge page with N, P, K gauges below it
class FertilityGaugePage extends StatelessWidget {
  const FertilityGaugePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gauge Chart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      // No scrolling needed
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Fertility gauge chart

            GaugeChart(
              value: 2*0.7, // Example value for fertility chart
              minValue: 0,
              maxValue: 2,
              goodMin: 1.33,
              goodMax: 2.0,
              midMin: 0.66,
              midMax: 1.33,
              size: 150, // Reduced size for Fertility chart
            ),
            const SizedBox(height: 15),
            const Text('Fertility Level', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 40),

            // Row of N, P, K gauges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [

                    GaugeChart(value: 70, minValue: 0, maxValue: 200, goodMin: 50, goodMax: 150, size: 100),
                    const SizedBox(height: 15),
                    Text('Nitrogen (N)', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  children: const [

                    GaugeChart(value: 80, minValue: 0, maxValue: 150, goodMin: 10, goodMax: 50, size: 100),
                    const SizedBox(height: 15),
                    Text('Phosphorus (P)', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  children: const [

                    GaugeChart(value: 100, minValue: 0, maxValue: 300, goodMin: 80, goodMax: 250, size: 100),
                    const SizedBox(height: 15),
                    Text('Potassium (K)', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom semicircle gauge chart for N, P, K
class GaugeChart extends StatelessWidget {
  final double value; // Value for N, P, K (should be between min and max)
  final double minValue;
  final double maxValue;
  final double goodMin;
  final double goodMax;
  final double? midMin; // Optional middle range min (for fertility chart)
  final double? midMax; // Optional middle range max (for fertility chart)
  final double size; // Size of the chart

  const GaugeChart({
    required this.value,
    this.minValue = 0.0,
    this.maxValue = 2.0,
    this.goodMin = 0.5,
    this.goodMax = 1.5,
    this.midMin,
    this.midMax,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CustomPaint(
        painter: GaugeChartPainter(
          value: value,
          minValue: minValue,
          maxValue: maxValue,
          goodMin: goodMin,
          goodMax: goodMax,
          midMin: midMin,
          midMax: midMax,
        ),
      ),
    );
  }
}

class GaugeChartPainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final double goodMin;
  final double goodMax;
  final double? midMin;
  final double? midMax;

  GaugeChartPainter({
    required this.value,
    this.minValue = 0.0,
    this.maxValue = 2.0,
    this.goodMin = 0.5,
    this.goodMax = 1.5,
    this.midMin,
    this.midMax,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const startAngle = 3.14; // Start from 180 degrees
    const sweepAngle = 3.14; // 180-degree semicircle

    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height);

    // Paint for the bad range (red)
    final badPaint = Paint()
      ..color = Color.fromARGB(255, 255, 95, 46)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // Paint for the middle range (yellow), only if midMin and midMax are defined
    final midPaint = Paint()
      ..color = Color.fromARGB(255, 255, 213, 46)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // Paint for the good range (green)
    final goodPaint = Paint()
      ..color = Color.fromARGB(255, 156, 196, 45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    // Red segment (bad range)
    final redSweep = (midMin != null ? midMin! : goodMin - minValue) / (maxValue - minValue) * sweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      redSweep,
      false,
      badPaint,
    );

    // Yellow segment (middle range)
    if (midMin != null && midMax != null) {
      final yellowSweep = (midMax! - midMin!) / (maxValue - minValue) * sweepAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + redSweep,
        yellowSweep,
        false,
        midPaint,
      );
    }

    // Green segment (good range)
    final greenSweep = (goodMax - goodMin) / (maxValue - minValue) * sweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + redSweep + (midMin != null ? (midMax! - midMin!) / (maxValue - minValue) * sweepAngle : 0),
      greenSweep,
      false,
      goodPaint,
    );

    // Red segment for excessive range
    final excessSweep = (maxValue - goodMax) / (maxValue - minValue) * sweepAngle;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle + redSweep + greenSweep,
      excessSweep,
      false,
      badPaint,
    );

    // Draw needle
    final needlePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final needleLength = radius - 12;
    final normalizedValue = (value - minValue) / (maxValue - minValue);
    final needleAngle = startAngle + normalizedValue * sweepAngle;

    final needleX = center.dx + needleLength * cos(needleAngle);
    final needleY = center.dy + needleLength * sin(needleAngle);

    canvas.drawLine(center, Offset(needleX, needleY), needlePaint);

    // Value label
    final valuePainter = _buildTextPainter('${value.toStringAsFixed(1)}');
    valuePainter.paint(canvas, Offset(size.width / 2 - 15, size.height / 2 - 35));
  }

  TextPainter _buildTextPainter(String text, {double fontSize = 18}) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(color: Colors.black, fontSize: fontSize),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    return textPainter;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
