import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firestore_service.dart';
import 'motor_log.dart';


void main() async {
  List<MotorLog> motorLogs = [
    MotorLog.withStartTime(cropWaterRequirement: 10.0, startTime: DateTime(2024, 10, 8, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 9.5, startTime: DateTime(2024, 10, 7, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 9.0, startTime: DateTime(2024, 10, 6, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 8.5, startTime: DateTime(2024, 10, 5, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 8.0, startTime: DateTime(2024, 10, 4, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 7.5, startTime: DateTime(2024, 10, 3, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 7.0, startTime: DateTime(2024, 10, 2, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 6.5, startTime: DateTime(2024, 10, 1, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 6.0, startTime: DateTime(2024, 9, 30, 14, 0)),
    MotorLog.withStartTime(cropWaterRequirement: 5.5, startTime: DateTime(2024, 9, 29, 14, 0)),
  ];

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirestoreService().storeMotorLogs(motorLogs);
}
