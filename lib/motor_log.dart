import 'dart:math';

class MotorLog {
  final DateTime startTime;
  final DateTime stopTime;
  final double duration; // in minutes
  final double energyConsumed; // in kWh
  final double cropWaterRequirement; // in Litres per Sq. Meter
  static const double hp = 5.0; // Constant horsepower for all objects

  // Constructor that calculates duration and energy based on CWR
  MotorLog({required this.cropWaterRequirement})
      : duration = _calculateDuration(cropWaterRequirement),
        energyConsumed = _calculateEnergyUsed(cropWaterRequirement),
        startTime = DateTime.now(),
        stopTime = DateTime.now().add(Duration(minutes: _calculateDuration(cropWaterRequirement).toInt()));

  // Constructor that takes a custom start time and calculates stop time, duration, and energy
  MotorLog.withStartTime({required this.cropWaterRequirement, required this.startTime})
      : duration = _calculateDuration(cropWaterRequirement),
        energyConsumed = _calculateEnergyUsed(cropWaterRequirement),
        stopTime = startTime.add(Duration(minutes: _calculateDuration(cropWaterRequirement).toInt()));

  // Function to calculate the duration needed for irrigation
  static double _calculateDuration(double cwr) {
    const double area = 1000.0; // Assume field area is 1000 sq. meters
    // Time (in minutes) = (HP * 56) / CWR
    return (cwr * area) / (hp * 56);
  }

  // Function to calculate energy used (kWh) based on duration
  static double _calculateEnergyUsed(double cwr) {
    double timeInHours = _calculateDuration(cwr) / 60; // Convert minutes to hours
    return hp * timeInHours;
  }

  @override
  String toString() {
    return '''
Motor Log:
  Start Time: $startTime
  Stop Time: $stopTime
  Duration: ${duration.toStringAsFixed(2)} minutes
  Energy Consumed: ${energyConsumed.toStringAsFixed(2)} kWh
  CWR: ${cropWaterRequirement.toStringAsFixed(2)} L/sq.m
''';
  }


}

void main() {
  List<MotorLog> motorLogs = [
    MotorLog.withStartTime(cropWaterRequirement: 10.0, startTime: DateTime(2024, 10, 8, 14, 0)), // Oct 8, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 9.5, startTime: DateTime(2024, 10, 7, 14, 0)),  // Oct 7, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 9.0, startTime: DateTime(2024, 10, 6, 14, 0)),  // Oct 6, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 8.5, startTime: DateTime(2024, 10, 5, 14, 0)),  // Oct 5, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 8.0, startTime: DateTime(2024, 10, 4, 14, 0)),  // Oct 4, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 7.5, startTime: DateTime(2024, 10, 3, 14, 0)),  // Oct 3, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 7.0, startTime: DateTime(2024, 10, 2, 14, 0)),  // Oct 2, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 6.5, startTime: DateTime(2024, 10, 1, 14, 0)),  // Oct 1, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 6.0, startTime: DateTime(2024, 9, 30, 14, 0)),  // Sep 30, 2024, 14:00
    MotorLog.withStartTime(cropWaterRequirement: 5.5, startTime: DateTime(2024, 9, 29, 14, 0)),  // Sep 29, 2024, 14:00
  ];

  // Print all log objects
  for (var log in motorLogs) {
    print(log);
  }
}
