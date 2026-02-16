import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/cloud_functions_service.dart';

/// Demo screen showcasing Firebase Cloud Functions integration
/// Demonstrates both callable functions and Firestore triggers
class CloudFunctionsDemoScreen extends StatefulWidget {
  const CloudFunctionsDemoScreen({super.key});

  @override
  State<CloudFunctionsDemoScreen> createState() => _CloudFunctionsDemoScreenState();
}

class _CloudFunctionsDemoScreenState extends State<CloudFunctionsDemoScreen> {
  final CloudFunctionsService _functionsService = CloudFunctionsService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final TextEditingController _plantNameController = TextEditingController(text: 'Monstera');
  final TextEditingController _userNameController = TextEditingController(text: 'Alex');
  final TextEditingController _wateringFrequencyController = TextEditingController(text: '7');
  
  String _greetingMessage = '';
  String _wateringInfo = '';
  bool _isLoading = false;
  String _firestoreTriggerStatus = '';

  @override
  void dispose() {
    _plantNameController.dispose();
    _userNameController.dispose();
    _wateringFrequencyController.dispose();
    super.dispose();
  }

  /// Call the greeting cloud function
  Future<void> _callGreetingFunction() async {
    setState(() {
      _isLoading = true;
      _greetingMessage = '';
    });

    final result = await _functionsService.getPlantCareGreeting(
      plantName: _plantNameController.text,
      userName: _userNameController.text,
    );

    setState(() {
      _isLoading = false;
      if (result['success']) {
        _greetingMessage = result['data']['message'];
      } else {
        _greetingMessage = 'Error: ${result['error']}';
      }
    });
  }

  /// Call the watering calculation function
  Future<void> _callWateringFunction() async {
    setState(() {
      _isLoading = true;
      _wateringInfo = '';
    });

    final result = await _functionsService.calculateNextWatering(
      wateringFrequency: int.parse(_wateringFrequencyController.text),
      lastWatered: DateTime.now().toIso8601String(),
    );

    setState(() {
      _isLoading = false;
      if (result['success']) {
        final data = result['data'];
        _wateringInfo = 'Next watering: ${data['nextWateringDate']}\n'
            'Days until watering: ${data['daysUntilWatering']}\n'
            'Status: ${data['status']}';
      } else {
        _wateringInfo = 'Error: ${result['error']}';
      }
    });
  }

  /// Trigger Firestore onCreate function by adding a new plant
  Future<void> _triggerFirestoreFunction() async {
    setState(() {
      _isLoading = true;
      _firestoreTriggerStatus = 'Creating plant document...';
    });

    try {
      final docRef = await _firestore.collection('plants').add({
        'name': _plantNameController.text,
        'species': 'Demo Plant',
        'wateringFrequency': int.parse(_wateringFrequencyController.text),
        'addedBy': _userNameController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _firestoreTriggerStatus = 'Plant created! ID: ${docRef.id}\n'
            'Check Firebase Console → Functions → Logs to see the trigger execution.';
      });
    } catch (e) {
      setState(() {
        _firestoreTriggerStatus = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Functions Demo'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Fields Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Input Parameters',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _plantNameController,
                      decoration: const InputDecoration(
                        labelText: 'Plant Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_florist),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        labelText: 'User Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _wateringFrequencyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Watering Frequency (days)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.water_drop),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Callable Functions Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. Callable Functions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _callGreetingFunction,
                      icon: const Icon(Icons.waving_hand),
                      label: const Text('Get Greeting'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    
                    if (_greetingMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _greetingMessage,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _callWateringFunction,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calculate Next Watering'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    
                    if (_wateringInfo.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _wateringInfo,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Firestore Trigger Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2. Firestore Trigger (onCreate)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This will create a new plant document and trigger the onNewPlantAdded function automatically.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _triggerFirestoreFunction,
                      icon: const Icon(Icons.add_circle),
                      label: const Text('Create Plant (Trigger Function)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    
                    if (_firestoreTriggerStatus.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _firestoreTriggerStatus,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Instructions Card
            Card(
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'How to Test',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Deploy functions: cd functions && npm install && firebase deploy --only functions\n'
                      '2. Test callable functions using the buttons above\n'
                      '3. Check Firebase Console → Functions → Logs for execution details\n'
                      '4. Firestore triggers run automatically when documents are created',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
