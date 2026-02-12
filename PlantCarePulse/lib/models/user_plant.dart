import 'plant.dart';

class UserPlant {
  final String id;
  final Plant plant;
  final String nickname;
  final DateTime dateAdded;
  DateTime? lastWatered;
  final String location;
  String notes;

  UserPlant({
    required this.id,
    required this.plant,
    required this.nickname,
    required this.dateAdded,
    this.lastWatered,
    required this.location,
    this.notes = '',
  });

  DateTime get nextWateringDate {
    if (lastWatered == null) {
      return DateTime.now();
    }
    return lastWatered!.add(Duration(days: plant.wateringFrequencyDays));
  }

  int get daysUntilWatering {
    return nextWateringDate.difference(DateTime.now()).inDays;
  }

  bool get needsWatering {
    return daysUntilWatering <= 0;
  }

  String get wateringStatus {
    if (needsWatering) return 'Needs Water Now!';
    if (daysUntilWatering == 1) return 'Water Tomorrow';
    return 'Water in $daysUntilWatering days';
  }

  void water() {
    lastWatered = DateTime.now();
  }
}
