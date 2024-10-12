import 'dart:math';

class IrrigationData {
  final DateTime date;  // Date and time
  final double temperature;  // Temperature in Celsius
  final double humidity;  // Humidity in percentage
  final double windSpeed;  // Windspeed in KMPH
  final double cropWaterRequirement;  // Water requirement in Litres per Sq.M
  final double rainfall;  // Rainfall in mm per day
  static const double hp = 5.0; // Common HP of the motor (can be adjusted as needed)
  static const double area = 1000.0;
  static const double rad = 10.9;
  // Common area of the field in square meters (can be adjusted as needed)

  IrrigationData({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.cropWaterRequirement,
    required this.rainfall,  // New rainfall parameter
  });

  // Overloaded constructor to calculate CWR based on temperature, humidity, and windSpeed
  IrrigationData.calculateCWR({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.rainfall,  // New rainfall parameter
  })  : cropWaterRequirement = _calculateCWR(temperature, humidity, windSpeed, rainfall);

  // Method to calculate CWR based on temperature, humidity, windSpeed, and rainfall
  static double _calculateCWR(double temperature, double humidity, double windSpeed, double rainfall) {
    return calculateET(temperature, humidity, windSpeed * 0.278, rad, rainfall);
  }

  static double calculateET(double T, double RH, double U, double Rn, double P) {
    // Constants
    double MW = 0.622;
    double cp = 0.001005;
    double lam = 2.45;

    // Calculate gamma
    double gamma = (cp * P) / (lam * MW);

    // Calculate es and ea
    double es = 0.6108 * exp((17.27 * T) / (T + 237.3));
    double ea = es * RH / 100; // RH as a percentage

    // Calculate f, W, and s
    double f = 0.27 * (1 + (U / 100));
    double W = 900 / (T + 273);
    double s = 4098 * es / pow((T + 237.3), 2);

    // Calculate c
    double c = (1 + 0.34 * U) * gamma + s;

    // Calculate ET
    double ET = c * (W * Rn + (1 - W) * f * (es - ea));

    return ET;
  }

  // Function to calculate the time needed for irrigation
  double calculateIrrigationTime() {
    // Time (in minutes) = (HP * 56) / CWR
    return (cropWaterRequirement * area) / (hp * 56);
  }

  // Function to calculate energy used (assuming energy used is HP over time in hours)
  double calculateEnergyUsed() {
    // Energy (in kWh) = HP * Time (in hours)
    double timeInHours = calculateIrrigationTime() / 60; // Convert minutes to hours
    return hp * timeInHours;
  }

  @override
  String toString() {
    return '''
IrrigationData:
  Date: $date
  Temperature: $temperature°C
  Humidity: $humidity%
  WindSpeed: $windSpeed km/h
  Rainfall: $rainfall mm
  Crop Water Requirement: ${cropWaterRequirement.toStringAsFixed(2)} L
  Motor HP: $hp
  Field Area: $area m²
  Irrigation Time: ${calculateIrrigationTime().toStringAsFixed(2)} minutes
  Energy Used: ${calculateEnergyUsed().toStringAsFixed(2)} kWh
''';
  }
}

void main() {
  List<IrrigationData> irrigationDataList = [
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 1, 9, 30, 35),
      temperature: 26,
      humidity: 60,
      windSpeed: 5,
      rainfall: 10.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 2, 10, 20, 30),
      temperature: 28,
      humidity: 55,
      windSpeed: 4,
      rainfall: 8.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 3, 11, 15, 45),
      temperature: 25,
      humidity: 65,
      windSpeed: 6,
      rainfall: 12.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 4, 12, 50, 10),
      temperature: 24,
      humidity: 58,
      windSpeed: 3,
      rainfall: 7.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 5, 8, 40, 25),
      temperature: 30,
      humidity: 45,
      windSpeed: 7,
      rainfall: 15.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 6, 14, 33, 12),
      temperature: 27,
      humidity: 52,
      windSpeed: 8,
      rainfall: 5.5, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 7, 16, 12, 50),
      temperature: 29,
      humidity: 49,
      windSpeed: 5,
      rainfall: 3.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 8, 9, 5, 35),
      temperature: 22,
      humidity: 70,
      windSpeed: 9,
      rainfall: 20.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 9, 18, 50, 15),
      temperature: 26,
      humidity: 60,
      windSpeed: 4,
      rainfall: 9.0, // Rainfall in mm per day
    ),
    IrrigationData.calculateCWR(
      date: DateTime(2024, 8, 10, 17, 25, 55),
      temperature: 25,
      humidity: 62,
      windSpeed: 6,
      rainfall: 11.0, // Rainfall in mm per day
    ),
  ];

  // Print the generated data
  for (var data in irrigationDataList) {
    print(data);
  }
}

