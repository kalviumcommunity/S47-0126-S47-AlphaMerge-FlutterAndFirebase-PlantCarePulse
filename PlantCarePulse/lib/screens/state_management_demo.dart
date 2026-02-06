import 'package:flutter/material.dart';

class StateManagementDemo extends StatefulWidget {
  @override
  _StateManagementDemoState createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('State Management Demo'),
        backgroundColor: _counter >= 10 ? Colors.green : Colors.blue,
      ),
      body: Container(
        color: _counter >= 5 ? Colors.greenAccent.withOpacity(0.2) : Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _counter >= 10 ? Icons.celebration : Icons.touch_app,
                size: 80,
                color: _counter >= 10 ? Colors.green : Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Button pressed:',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
              SizedBox(height: 10),
              Text(
                '$_counter times',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _counter >= 10 ? Colors.green : Colors.blue,
                ),
              ),
              SizedBox(height: 10),
              if (_counter >= 5)
                Text(
                  _counter >= 10 ? '🎉 Great job!' : '⚡ Keep going!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: _counter >= 10 ? Colors.green : Colors.orange,
                  ),
                ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _decrementCounter,
                    icon: Icon(Icons.remove),
                    label: Text('Decrement'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                  SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: Icon(Icons.add),
                    label: Text('Increment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _resetCounter,
                icon: Icon(Icons.refresh),
                label: Text('Reset'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
