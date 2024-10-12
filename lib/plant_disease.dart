import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'models/solution_card.dart';

void main() {
  runApp(MaterialApp(home: ImageUploadApp()));
}

class ImageUploadApp extends StatefulWidget {
  ImageUploadApp({super.key});

  @override
  _ImageUploadAppState createState() => _ImageUploadAppState();
}

class _ImageUploadAppState extends State<ImageUploadApp> {
  File? _image;
  final picker = ImagePicker();
  String _prediction = '';
  List<String> _solutions = [];

  Future<void> _pickImage() async {
    // Show a dialog to choose between camera and gallery
    final pickedFile = await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop(await picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop(await picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage(File image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.106.12.205:5000/predict_disease'),
      );

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonData = jsonDecode(responseData.body);

        // Use setState to update UI
        if (mounted) {
          setState(() {
            _prediction = jsonData['prediction'] ?? 'No prediction available';
            _solutions = List<String>.from(jsonData['solutions'] ?? []);
          });

          print(_prediction);
          print(_solutions);
        }
      } else {
        var responseData = await http.Response.fromStream(response);
        print('Image upload failed: ${responseData.body}');
      }
    } catch (error) {
      print('Error occurred while uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plant Disease Detection')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _image == null
                  ? Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('No image selected.')),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _image!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
              ElevatedButton(
                  onPressed: _pickImage, child: const Text('Select Image')),
              ElevatedButton(
                  onPressed:
                  _image != null ? () => _uploadImage(_image!) : null,
                  child: const Text('Identify Disease')),
              const SizedBox(height: 20),
              if (_prediction != '')
                const Text(
                  'Prediction:',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              Text(
                _prediction,
                style: TextStyle(
                  fontSize: 30,
                  color: _solutions.isEmpty ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              if (_solutions.isNotEmpty)
                Text(
                  'Methods to Follow to Cure:',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ..._solutions.map((solution) {
                return SolutionCard(solution);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
