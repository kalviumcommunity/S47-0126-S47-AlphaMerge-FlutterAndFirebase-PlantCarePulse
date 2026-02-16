import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';

/// Service class for interacting with Firebase Cloud Functions
/// Provides methods to call callable functions and handle responses
class CloudFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  CloudFunctionsService() {
    // Connect to Firebase Emulator for local testing
    _functions.useFunctionsEmulator('localhost', 5001);
  }

  /// Get a personalized plant care greeting
  /// 
  /// Parameters:
  /// - [plantName]: Name of the plant
  /// - [userName]: Name of the user
  /// 
  /// Returns a greeting message with timestamp
  Future<Map<String, dynamic>> getPlantCareGreeting({
    required String plantName,
    required String userName,
  }) async {
    try {
      final callable = _functions.httpsCallable('getPlantCareGreeting');
      final result = await callable.call({
        'plantName': plantName,
        'userName': userName,
      });
      
      return {
        'success': true,
        'data': result.data,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Calculate the next watering date for a plant
  /// 
  /// Parameters:
  /// - [wateringFrequency]: Number of days between waterings
  /// - [lastWatered]: ISO string of last watering date
  /// 
  /// Returns next watering date and days until watering
  Future<Map<String, dynamic>> calculateNextWatering({
    required int wateringFrequency,
    required String lastWatered,
  }) async {
    try {
      final callable = _functions.httpsCallable('calculateNextWatering');
      final result = await callable.call({
        'wateringFrequency': wateringFrequency,
        'lastWatered': lastWatered,
      });
      
      return {
        'success': true,
        'data': result.data,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
