import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String icon;
  final String time;
  final String value;
  const HourlyForecastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 0,
        color: const Color.fromARGB(255, 24, 28, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 13.9, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(icon, style: TextStyle(fontSize: 25)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
