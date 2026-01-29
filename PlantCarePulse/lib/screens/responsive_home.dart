import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Responsive Screen")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const Center(child: Text("Mobile View 📱"));
          } else {
            return const Center(child: Text("Tablet/Desktop View 💻"));
          }
        },
      ),
    );
  }
}
