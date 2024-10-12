import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

 // Fixed the import name
import 'firestore_service.dart';
import 'irrigation_data.dart';
import 'motor_log.dart'; // Import your MotorLog class
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class IrrigationDataDisplay extends StatefulWidget {
  @override
  _IrrigationDataDisplayState createState() => _IrrigationDataDisplayState();
}

class _IrrigationDataDisplayState extends State<IrrigationDataDisplay> {
  bool isMotorRunning = false; // Flag to check if the motor is running
  late double timeLeft; // Time left for motor to switch off
  Timer? _timer; // Timer instance
  Future<IrrigationData?>? irrigationDataFuture; // Future for Firebase data
  DateTime? latestStopTime; // Store latest stop time

  @override
  void initState() {
    super.initState();
    // Fetch the latest irrigation data from Firebase when the widget initializes
    irrigationDataFuture = FirestoreService().fetchLatestIrrigationDataWithoutCWR();
    _loadLatestMotorLog(); // Load the latest motor log to check status
  }

  // Load the latest motor log to check if the motor is running
  Future<void> _loadLatestMotorLog() async {
    latestStopTime = await FirestoreService().fetchLatestStopTime(); // Your function to get the latest stop time
    if (latestStopTime != null && latestStopTime!.isAfter(DateTime.now())) {
      setState(() {
        isMotorRunning = true;
        timeLeft = latestStopTime!.difference(DateTime.now()).inSeconds.toDouble();
        _startTimer(); // Start the timer if the motor is running
      });
    }
  }

  // Start the motor and countdown
  void _startMotor(IrrigationData irrigationData) {
    setState(() {
      isMotorRunning = true;
      timeLeft = irrigationData.calculateIrrigationTime() * 60; // Reset time left to seconds
    });

    // Create a motor log record
    MotorLog log = MotorLog(cropWaterRequirement: irrigationData.cropWaterRequirement);
    FirestoreService().storeSingleMotorLog(log); // Store log in Firestore

    _startTimer(); // Start the timer for countdown
  }

  String _formatTime(double seconds) {
    int minutes = (seconds / 60).floor(); // Get the whole minutes
    int secs = (seconds % 60).floor(); // Get the remaining seconds
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}'; // Format as min:sec
  }

  // Start the countdown timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 1) {
          timeLeft -= 1; // Decrease time left
        } else {
          // Stop the timer when it reaches 0
          timer.cancel();
          isMotorRunning = false;
        }
      });
    });
  }

  @override
  void dispose() {
    // Clean up the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IrrigationData?>(
      future: irrigationDataFuture, // Use the future to fetch data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching data')); // Handle errors
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data available')); // Handle no data scenario
        }

        final irrigationData = snapshot.data!; // Safe to use the fetched data

        return SingleChildScrollView( // Add SingleChildScrollView for vertical scrolling
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display Humidity, Temperature, and Wind Speed with increased font sizes
              _buildRow(FontAwesomeIcons.tint, 'Humidity', '${irrigationData.humidity.toStringAsFixed(1)}%', Colors.blue, 18),
              SizedBox(height: 20), // Increase the space between rows
              _buildRow(FontAwesomeIcons.thermometerHalf, 'Temperature', '${irrigationData.temperature.toStringAsFixed(1)}°C', Colors.blue, 18),
              SizedBox(height: 20),
              _buildRow(FontAwesomeIcons.wind, 'Wind Speed', '${irrigationData.windSpeed.toStringAsFixed(1)} km/h', Colors.blue, 18),
              SizedBox(height: 20),
              _buildRow(FontAwesomeIcons.cloudRain, 'Rainfall', '${irrigationData.rainfall.toStringAsFixed(1)} mm', Colors.blue, 18), // Fixed Rainfall display
              SizedBox(height: 20),
              Container(
                width: 250,  // Increased width
                height: 250, // Increased height
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                  //color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Crop Water\nRequirement',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 7),
                    Text(
                      (irrigationData.cropWaterRequirement * 4046.85642).toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Litres/acre',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'The motor needs to run for',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '${irrigationData.calculateIrrigationTime().toStringAsFixed(2)} mins',
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // Space before the button
              Center(
                child: ElevatedButton(
                  onPressed: isMotorRunning
                      ? null // Disable the button when the motor is running
                      : () {
                    _startMotor(irrigationData); // Start motor if not running
                  },
                  child: Text(isMotorRunning ? 'Motor Running' : 'Start Motor'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                ),
              ),
              // Timer display: Show time left when the motor is running with increased font size
              if (isMotorRunning)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'The motor switches off in\n ${_formatTime(timeLeft)} seconds',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              // Display motor status
              Text(
                isMotorRunning ? 'Motor Status: ON' : 'Motor Status: OFF',
                style: TextStyle(fontSize: 18, color: isMotorRunning ? Colors.green : Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build rows for displaying data (Icon + Label + Value)
  Widget _buildRow(IconData icon, String label, String value, Color iconColor, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, color: iconColor),
        SizedBox(width: 8),
        Expanded(child: Text(label, style: TextStyle(fontSize: fontSize))),
        Text(value, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }
}

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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Irrigation Data Display'),
        ),
        body: IrrigationDataDisplay(),
      ),
    );
  }
}
