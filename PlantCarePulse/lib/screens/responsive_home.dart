import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text("Responsive Layout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔷 HEADER
            Container(
              height: 120,
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.blueAccent,
              child: const Text(
                "PlantCare Dashboard",
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),

            const SizedBox(height: 16),

            // 🔷 MAIN CONTENT
            Expanded(
              child: isTablet
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.greenAccent,
                            child: const Center(child: Text("Plant Status")),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            color: Colors.lightGreen,
                            child: const Center(child: Text("Water Schedule")),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.greenAccent,
                            child: const Center(child: Text("Plant Status")),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            color: Colors.lightGreen,
                            child: const Center(child: Text("Water Schedule")),
                          ),
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 16),

            // 🔷 FOOTER
            Container(
              height: 60,
              width: double.infinity,
              alignment: Alignment.center,
              color: Colors.blueGrey,
              child: const Text(
                "Responsive Layout Example",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
