import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'firestore_service.dart';
import 'models/gauge_chart.dart';
import 'models/soil_data.dart';

var firestoreService = FirestoreService();

class SoilDataForm extends StatefulWidget {
  const SoilDataForm({super.key});

  @override
  _SoilDataFormState createState() => _SoilDataFormState();
}

class _SoilDataFormState extends State<SoilDataForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field with default values
  final TextEditingController nController = TextEditingController(text: '10.0');
  final TextEditingController pController = TextEditingController(text: '10.0');
  final TextEditingController kController = TextEditingController(text: '10.0');
  final TextEditingController phController = TextEditingController(text: '7.0');
  final TextEditingController ecController = TextEditingController(text: '1.0');
  final TextEditingController ocController = TextEditingController(text: '1.0');
  final TextEditingController sController = TextEditingController(text: '10.0');
  final TextEditingController znController = TextEditingController(text: '1.0');
  final TextEditingController feController = TextEditingController(text: '1.0');
  final TextEditingController cuController = TextEditingController(text: '0.5');
  final TextEditingController mnController = TextEditingController(text: '0.5');
  final TextEditingController bController = TextEditingController(text: '0.5');

  String _prediction = '';
  SoilData? latestData; // Variable to hold the latest soil data

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      // Create the data payload
      var data = {
        "N": double.parse(nController.text),
        "P": double.parse(pController.text),
        "K": double.parse(kController.text),
        "ph": double.parse(phController.text),
        "ec": double.parse(ecController.text),
        "oc": double.parse(ocController.text),
        "S": double.parse(sController.text),
        "zn": double.parse(znController.text),
        "fe": double.parse(feController.text),
        "cu": double.parse(cuController.text),
        "mn": double.parse(mnController.text),
        "b": double.parse(bController.text),
      };

      // Make HTTP POST request to the Flask backend
      var response = await http.post(
        Uri.parse('http://10.106.12.205:5000/predict_soil'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          _prediction = responseData['prediction'];
          latestData = SoilData(
            // Update the latest data here
            b: data['b'],
            k: data['K'],
            mn: data['mn'],
            n: data['N'],
            p: data['P'],
            s: data['S'],
            cu: data['cu'],
            ec: data['ec'],
            fe: data['fe'],
            oc: data['oc'],
            ph: data['ph'],
            zn: data['zn'],
            fertility: double.parse(_prediction),
            time: DateTime.now(),
          );
        });
      } else {
        print('Failed to get prediction.');
      }

      // Storing soil data in Firebase
      var soilData = SoilData(
        b: data['b'],
        k: data['K'],
        mn: data['mn'],
        n: data['N'],
        p: data['P'],
        s: data['S'],
        cu: data['cu'],
        ec: data['ec'],
        fe: data['fe'],
        oc: data['oc'],
        ph: data['ph'],
        zn: data['zn'],
        fertility: double.parse(_prediction),
        time: DateTime.now(), // Set the current time as default
      );
      await firestoreService.addSoilData1(soilData);
    }
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
        title: Text('Soil Fertility Prediction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildInputRowThree(
                'N - Nitrogen',
                nController,
                'P - Phosphorous',
                pController,
                'K - Potassium',
                kController,
              ),
              buildInputRowTwo(
                'pH',
                phController,
                'EC - Electrical Conductivity',
                ecController,
              ),
              buildInputRowThree(
                'OC - Organic Carbon',
                ocController,
                'S - Sulfur',
                sController,
                'Zn - Zinc',
                znController,
              ),
              buildInputRowTwo(
                'Fe - Iron',
                feController,
                'Cu - Copper',
                cuController,
              ),
              buildInputRowTwo(
                'Mn - Manganese',
                mnController,
                'B - Boron',
                bController,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Text('Submit'),
              ),
              SizedBox(height: 25),
              if(_prediction!='')
                Text(
                  'Prediction: $_prediction',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(
                height: 50,
              ),

              // Add Gauge Charts for each parameter if latestData is available
              if (latestData != null) ...[
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
                SizedBox(height: 20,),
                GaugeChart(
                  value: (latestData!.fertility ??
                      0.0), // Example value for fertility chart
                  // Example value for fertility chart
                  minValue: 0,
                  maxValue: 1,
                  goodMin: 0.66,
                  goodMax: 1,
                  midMin: 0.33,
                  midMax: 0.66,
                  size: 125, //
                ),
                const SizedBox(height: 15),
                const Text(
                  'Fertility Level',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
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
                      children:  [
                        GaugeChart(
                            value: latestData!.n ??
                                0.0,
                            minValue: 0,
                            maxValue: 200,
                            goodMin: 50,
                            goodMax: 150,
                            size: 100),
                        const SizedBox(height: 15),
                        Text('N', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children:  [
                        GaugeChart(
                            value: latestData!.p ??
                                0.0,
                            minValue: 0,
                            maxValue: 150,
                            goodMin: 10,
                            goodMax: 50,
                            size: 100),
                        const SizedBox(height: 15),
                        Text('P', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children:  [
                        GaugeChart(
                            value: latestData!.k ??
                                0.0,
                            minValue: 0,
                            maxValue: 300,
                            goodMin: 80,
                            goodMax: 250,
                            size: 100),
                        const SizedBox(height: 15),
                        Text('K', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputRowThree(
      String label1,
      TextEditingController controller1,
      String label2,
      TextEditingController controller2,
      String label3,
      TextEditingController controller3) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: buildInputField(label1, controller1),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildInputField(label2, controller2),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildInputField(label3, controller3),
          ),
        ],
      ),
    );
  }

  Widget buildInputRowTwo(String label1, TextEditingController controller1,
      String label2, TextEditingController controller2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: buildInputField(label1, controller1),
          ),
          SizedBox(width: 8),
          Expanded(
            child: buildInputField(label2, controller2),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
