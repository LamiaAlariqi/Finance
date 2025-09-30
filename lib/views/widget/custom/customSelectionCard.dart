import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final Widget child;

  const SectionCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}