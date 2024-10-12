import 'package:dummy/plant_disease.dart';
import 'package:dummy/soil_fertility.dart';
import 'package:dummy/soil_history.dart';
import 'package:flutter/material.dart';

import 'cures_page.dart';
import 'dashboard_page.dart';
import 'irrigation_history.dart';
import 'models/line_with_text.dart';
import 'irrigation_display.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);



  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[

      DashboardPage(onOptionTap: onItemTapped),

      ImageUploadApp(),

      SearchCuresPage(),

      SoilDataForm(),

      FertilityGraphScreen(),

      IrrigationDataDisplay(),

      IrrigationHistory(),

    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent.withOpacity(0.5),
                image: DecorationImage(
                  image: const NetworkImage(
                      'https://tse2.mm.bing.net/th?id=OIP.eny8Ke1Of4BCM5tcxgtP8QHaEK&pid=Api&P=0&h=180'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              child: Text(''),
            ),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.black87),
              ),
              selected: _selectedIndex == 0,
              onTap: () {
                onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            LineWithText(text: 'Plant'),
            ListTile(
              title: const Text(
                'Plant Disease Prediction',
                style: TextStyle(color: Colors.black87),
              ),
              selected: _selectedIndex == 1,
              onTap: () {
                onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Search Cures',
                style: TextStyle(color: Colors.black87),
              ),
              selected: _selectedIndex == 2,
              onTap: () {
                onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            LineWithText(text: 'Soil'),
            ListTile(
              title: const Text(
                'Soil Fertility Prediction',
                style: TextStyle(color: Colors.black87),
              ),
              selected: _selectedIndex == 3,
              onTap: () {
                onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Soil Fertility Analysis',
                style: TextStyle(color: Colors.black87),
              ),
              selected: _selectedIndex == 4,
              onTap: () {
                onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            LineWithText(text: 'Irrigation'),
            ListTile(
              title: const Text(
                'Crop Water Requirement',
                style: TextStyle(color: Colors.black87),
              ),
              selected: _selectedIndex == 5,
              onTap: () {
                onItemTapped(5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text(
                'Irrigation Analysis',
                style: TextStyle(color: Colors.black87),
              ),
              selected: _selectedIndex == 6,
              onTap: () {
                onItemTapped(6);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

