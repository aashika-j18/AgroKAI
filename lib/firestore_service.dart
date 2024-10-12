import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'irrigation_data.dart';
import 'models/soil_data.dart';
import 'motor_log.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the latest soil data (already implemented)
  Future<SoilData?> fetchLatestSoilData() async {
    try {
      CollectionReference soilDataCollection =
      FirebaseFirestore.instance.collection('soilData');

      // Get the latest document (sorted by timestamp)
      QuerySnapshot querySnapshot = await soilDataCollection
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract the data and map it to the SoilData class
        DocumentSnapshot doc = querySnapshot.docs.first;
        SoilData soilData =
        SoilData.fromFirestore(doc.data() as Map<String, dynamic>);
        return soilData;
      } else {
        print("No soil data found");
        return null;
      }
    } catch (e) {
      print("Error fetching soil data: $e");
      return null;
    }
  }

  // Function to add fertilityData field to the latest document
  Future<void> addFertilityData(double newFertility) async {
    try {
      CollectionReference soilDataCollection =
      FirebaseFirestore.instance.collection('soilData');

      // Get the latest document (sorted by timestamp)
      QuerySnapshot querySnapshot = await soilDataCollection
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Create fertilityData map with the new value
        Map<String, dynamic> fertilityData = {
          'fertilityData': {
            'fertility': newFertility,
            'updatedAt': Timestamp.now(), // Add a timestamp to track the update time
          },
        };

        // Add the fertilityData field to the latest document
        await doc.reference.update(fertilityData);
        print("Fertility data added successfully.");
      } else {
        print("No document found to update.");
      }
    } catch (e) {
      print("Error adding fertility data: $e");
    }
  }

  // Function to update fertility value for the latest document
  Future<void> updateLatestFertility(double newFertility) async {
    try {
      CollectionReference soilDataCollection =
      FirebaseFirestore.instance.collection('soilData');

      // Get the latest document (sorted by timestamp)
      QuerySnapshot querySnapshot = await soilDataCollection
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        // Update the fertility field of the latest document
        await doc.reference.update({'fertility': newFertility});
        print("Fertility value updated successfully.");
      } else {
        print("No document found to update.");
      }
    } catch (e) {
      print("Error updating fertility value: $e");
    }
  }

// Fetch the fertility, N, P, K values and timestamps for the latest n records
  Future<List<Map<String, dynamic>>> fetchLatestSoilData_n(int n) async {
    try {
      CollectionReference soilDataCollection =
      FirebaseFirestore.instance.collection('soilData');

      // Get the latest n documents (sorted by timestamp)
      QuerySnapshot querySnapshot = await soilDataCollection
          .orderBy('time', descending: true)
          .limit(n)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> soilDataList = [];

        // Loop through the documents and extract fertility, N, P, K, and time
        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          soilDataList.add({
            'fertility': data['fertility'],
            'N': data['N'],        // Nitrogen
            'P': data['P'],        // Phosphorous
            'K': data['K'],        // Potassium
            'time': (data['time'] as Timestamp).toDate(),
          });
        }

        return soilDataList;
      } else {
        print("No soil data found.");
        return [];
      }
    } catch (e) {
      print("Error fetching soil data: $e");
      return [];
    }
  }

  // Function to upload SoilData object to Firestore
  Future<void> addSoilData1(SoilData soilData) async {
    try {
      CollectionReference soilDataCollection =
      FirebaseFirestore.instance.collection('soilData');

      // Convert SoilData object to a map
      Map<String, dynamic> soilDataMap = {
        'B': soilData.b,
        'K': soilData.k,
        'Mn': soilData.mn,
        'N': soilData.n,
        'P': soilData.p,
        'S': soilData.s,
        'cu': soilData.cu,
        'ec': soilData.ec,
        'fe': soilData.fe,
        'fertility': soilData.fertility,
        'oc': soilData.oc,
        'ph': soilData.ph,
        'zn': soilData.zn, // Added Zn here
        'time': Timestamp.fromDate(soilData.time), // Convert DateTime to Timestamp
      };

      // Add the data to Firestore (this creates a new document in soilData collection)
      await soilDataCollection.add(soilDataMap);

      print("Soil data added successfully.");
    } catch (e) {
      print("Error adding soil data: $e");
    }
  }

  // Function to upload SoilData object to Firestore (excluding fertility)
  Future<void> addSoilDataWithoutFertility(SoilData soilData) async {
    try {
      CollectionReference soilDataCollection =
      FirebaseFirestore.instance.collection('soilData');

      // Convert SoilData object to a map excluding fertility
      Map<String, dynamic> soilDataMap = {
        'B': soilData.b,
        'K': soilData.k,
        'Mn': soilData.mn,
        'N': soilData.n,
        'P': soilData.p,
        'S': soilData.s,
        'cu': soilData.cu,
        'ec': soilData.ec,
        'fe': soilData.fe,
        'oc': soilData.oc,
        'ph': soilData.ph,
        'zn': soilData.zn, // Added Zn here too
        'time': Timestamp.fromDate(soilData.time), // Convert DateTime to Timestamp
      };

      // Add the data to Firestore (this creates a new document in soilData collection)
      await soilDataCollection.add(soilDataMap);

      print("Soil data (without fertility) added successfully.");
    } catch (e) {
      print("Error adding soil data: $e");
    }
  }

  // Function to upload SoilData from a JSON file
  Future<void> uploadSoilDataFromJson(String jsonFilePath) async {
    try {
      // Load JSON file from assets or specified path
      String jsonData = await rootBundle.loadString(jsonFilePath);

      // Decode JSON data into a List of Map objects
      List<dynamic> decodedData = json.decode(jsonData);

      for (var item in decodedData) {
        // Parse each item into a SoilData object
        SoilData soilData = SoilData(
          b: item['B'].toDouble(),
          k: item['K'].toDouble(),
          mn: item['Mn'].toDouble(),
          n: item['N'].toDouble(),
          p: item['P'].toDouble(),
          s: item['S'].toDouble(),
          cu: item['cu'].toDouble(),
          ec: item['ec'].toDouble(),
          fe: item['fe'].toDouble(),
          fertility: item['fertility'].toDouble(),
          oc: item['oc'].toDouble(),
          ph: item['ph'].toDouble(),
          zn: item['Zn'].toDouble(), // Added Zn here too
          time: DateTime.parse(item['time']), // Parse ISO format date string
        );

        // Upload the parsed SoilData object to Firestore
        await addSoilData1(soilData);
      }

      print("All soil data records uploaded successfully.");
    } catch (e) {
      print("Error uploading soil data from JSON: $e");
    }
  }

  // --------------- Irrigation Data ----------------

  Future<IrrigationData?> fetchLatestIrrigationData() async {
    try {
      CollectionReference irrigationDataCollection =
      FirebaseFirestore.instance.collection('irrigationData');

      // Get the latest document (sorted by timestamp)
      QuerySnapshot querySnapshot = await irrigationDataCollection
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract the data and map it to the IrrigationData class
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        IrrigationData irrigationData = IrrigationData(
          date: (data['date'] as Timestamp).toDate(),
          temperature: data['temperature'].toDouble(),
          humidity: data['humidity'].toDouble(),
          windSpeed: data['windSpeed'].toDouble(),
          cropWaterRequirement: data['cropWaterRequirement'].toDouble(),
          rainfall: data['rainfall'].toDouble(), // Added rainfall
        );
        return irrigationData;
      } else {
        print("No irrigation data found.");
        return null;
      }
    } catch (e) {
      print("Error fetching irrigation data: $e");
      return null;
    }
  }

// Function to update crop water requirement (CWR) value for the latest document
  Future<void> updateLatestCWR(double newCWR) async {
    try {
      CollectionReference irrigationDataCollection =
      FirebaseFirestore.instance.collection('irrigationData');

      // Get the latest document (sorted by timestamp)
      QuerySnapshot querySnapshot = await irrigationDataCollection
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Update the cropWaterRequirement field
        await doc.reference.update({'cropWaterRequirement': newCWR});
        print("Crop Water Requirement updated successfully.");
      } else {
        print("No document found to update.");
      }
    } catch (e) {
      print("Error updating Crop Water Requirement: $e");
    }
  }

  Future<List<IrrigationData>> fetchLatestIrrigationData_n(int n) async {
    try {
      CollectionReference irrigationDataCollection =
      FirebaseFirestore.instance.collection('irrigationData');

      // Get the latest n documents (sorted by date)
      QuerySnapshot querySnapshot = await irrigationDataCollection
          .orderBy('date', descending: true)
          .limit(n)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<IrrigationData> irrigationDataList = [];

        // Extract and add the data from each document
        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          irrigationDataList.add(IrrigationData(
            date: (data['date'] as Timestamp).toDate(),
            temperature: data['temperature'].toDouble(),
            humidity: data['humidity'].toDouble(),
            windSpeed: data['windSpeed'].toDouble(),
            cropWaterRequirement: data['cropWaterRequirement'].toDouble(),
            rainfall: data['rainfall'].toDouble(), // Added rainfall
          ));
        }

        return irrigationDataList;
      } else {
        print("No irrigation data found.");
        return [];
      }
    } catch (e) {
      print("Error fetching irrigation data: $e");
      return [];
    }
  }

// Function to upload IrrigationData object to Firestore
  Future<void> addIrrigationData(IrrigationData irrigationData) async {
    try {
      CollectionReference irrigationDataCollection =
      FirebaseFirestore.instance.collection('irrigationData');

      // Convert IrrigationData object to a map
      Map<String, dynamic> irrigationDataMap = {
        'date': Timestamp.fromDate(irrigationData.date),
        'temperature': irrigationData.temperature,
        'humidity': irrigationData.humidity,
        'windSpeed': irrigationData.windSpeed,
        'cropWaterRequirement': irrigationData.cropWaterRequirement,
        'rainfall': irrigationData.rainfall, // Added rainfall
      };

      // Add the data to Firestore (this creates a new document in irrigationData collection)
      await irrigationDataCollection.add(irrigationDataMap);

      print("Irrigation data added successfully.");
    } catch (e) {
      print("Error adding irrigation data: $e");
    }
  }

  Future<void> addCWRToLatestData(double newCWR) async {
    try {
      CollectionReference irrigationDataCollection =
      FirebaseFirestore.instance.collection('irrigationData');

      // Get the latest document (sorted by timestamp)
      QuerySnapshot querySnapshot = await irrigationDataCollection
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Update the cropWaterRequirement field
        await doc.reference.update({'cropWaterRequirement': newCWR});
        print("Crop Water Requirement added successfully.");
      } else {
        print("No document found to update.");
      }
    } catch (e) {
      print("Error adding Crop Water Requirement: $e");
    }
  }

  Future<IrrigationData?> fetchLatestIrrigationDataWithoutCWR() async {
    try {
      CollectionReference irrigationDataCollection =
      FirebaseFirestore.instance.collection('irrigationData');

      // Get the latest document (sorted by timestamp)
      QuerySnapshot querySnapshot = await irrigationDataCollection
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract the data and map it to the IrrigationData class without CWR
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        IrrigationData irrigationData = IrrigationData.calculateCWR(
          date: (data['date'] as Timestamp).toDate(),
          temperature: data['temperature'].toDouble(),
          humidity: data['humidity'].toDouble(),
          windSpeed: data['windSpeed'].toDouble(),// Set CWR to 0 or any default value
          rainfall: data['rainfall'].toDouble(), // Added rainfall
        );

        return irrigationData;
      } else {
        print("No irrigation data found.");
        return null;
      }
    } catch (e) {
      print("Error fetching irrigation data: $e");
      return null;
    }
  }

  // --------------- Motor Log Data ----------------

  Future<void> storeMotorLogs(List<MotorLog> motorLogs) async {
    CollectionReference motorLogCollection = FirebaseFirestore.instance.collection('motorLog');

    for (var log in motorLogs) {
      try {
        // Create a map directly from the log attributes
        Map<String, dynamic> logData = {
          'startTime': log.startTime,
          'stopTime': log.stopTime,
          'duration': log.duration,
          'energyConsumed': log.energyConsumed,
        };

        // Add the data to Firestore
        await motorLogCollection.add(logData);
        print("MotorLog stored successfully: $logData");
      } catch (e) {
        print("Error storing MotorLog: $e");
      }
    }
  }

  Future<void> storeSingleMotorLog(MotorLog log) async {
    CollectionReference motorLogCollection = FirebaseFirestore.instance.collection('motorLog');

    try {
      // Create a map directly from the log attributes
      Map<String, dynamic> logData = {
        'startTime': log.startTime,
        'stopTime': log.stopTime,
        'duration': log.duration,
        'energyConsumed': log.energyConsumed,
        'cropWaterRequirement': log.cropWaterRequirement,
        'hp': MotorLog.hp, // Accessing the static hp variable
      };

      // Add the data to Firestore
      await motorLogCollection.add(logData);
      print("MotorLog stored successfully: $logData");
    } catch (e) {
      print("Error storing MotorLog: $e");
    }
  }

  Future<DateTime?> fetchLatestStopTime() async {
    try {
      CollectionReference motorLogCollection = FirebaseFirestore.instance.collection('motorLog');

      // Get the latest document (sorted by start time)
      QuerySnapshot querySnapshot = await motorLogCollection
          .orderBy('startTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Extract the stopTime
        DateTime stopTime = (doc.data() as Map<String, dynamic>)['stopTime'].toDate();
        return stopTime;
      } else {
        print("No motor log data found.");
        return null;
      }
    } catch (e) {
      print("Error fetching latest stop time: $e");
      return null;
    }
  }

}
