import 'package:flutter/material.dart';

class AdditionalItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const AdditionalItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    // required forces caller to pass the values
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(icon, style: TextStyle(fontSize: 25)),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 17)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontSize: 17)),
      ],
    );
  }
}
