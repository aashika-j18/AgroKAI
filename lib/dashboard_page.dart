import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final Function(int) onOptionTap;

  const DashboardPage({super.key, required this.onOptionTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          DashboardOption(
            image: 'assets/images/crops.jpeg',
            title: 'Plant',
            onTap: () => onOptionTap(1), // Update the index for Plant Disease Prediction
          ),
          SizedBox(height: 20),
          DashboardOption(
            image: 'assets/images/soil.jpeg',
            title: 'Soil',
            onTap: () => onOptionTap(3), // Update the index for Soil Fertility Prediction
          ),
          SizedBox(height: 20),
          DashboardOption(
            image: 'assets/images/irrigation.jpeg',
            title: 'Irrigation',
            onTap: () => onOptionTap(5), // Update the index for Irrigation
          ),
        ],
      ),
    );
  }
}

class DashboardOption extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const DashboardOption({
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),

                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
