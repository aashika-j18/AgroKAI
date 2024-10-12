import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/solution_card.dart';

class SearchCuresPage extends StatefulWidget {
  @override
  _SearchCuresPageState createState() => _SearchCuresPageState();
}

class _SearchCuresPageState extends State<SearchCuresPage> {
  String _query = '';
  List<dynamic> _results = [];

  Future<void> _searchSolutions(String query) async {
    try {
      final response = await http.get(Uri.parse('http://10.106.12.205:5000/search_cures?query=$query'));

      if (response.statusCode == 200) {
        setState(() {
          _results = jsonDecode(response.body);
        });
        print(_results[0]['name']);
        print(_results[0]['solutions']);

      } else {
        print('Search failed: ${response.body}');
      }
    } catch (error) {
      print('Error occurred during search: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Cures'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
                _searchSolutions(value);
              },
              decoration: InputDecoration(
                labelText: 'Search Disease or Crop',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      SizedBox(height: 40,),
                      Text(_results[index]['name'],
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.left,),
                      ..._results[index]['solutions'].map((solution) {
                        return SolutionCard(solution);
                      }),
                      Divider(color: Colors.black12, thickness: 2),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
