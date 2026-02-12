class Plant {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String imageEmoji;
  final int wateringFrequencyDays;
  final String sunlight;
  final String difficulty;
  final String description;
  final List<String> careTips;

  Plant({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.imageEmoji,
    required this.wateringFrequencyDays,
    required this.sunlight,
    required this.difficulty,
    required this.description,
    required this.careTips,
  });

  // Sample plant data
  static List<Plant> getSamplePlants() {
    return [
      Plant(
        id: '1',
        name: 'Snake Plant',
        scientificName: 'Sansevieria trifasciata',
        category: 'Indoor',
        imageEmoji: '🌿',
        wateringFrequencyDays: 14,
        sunlight: 'Low to Bright Indirect',
        difficulty: 'Easy',
        description: 'A hardy plant that thrives on neglect. Perfect for beginners.',
        careTips: [
          'Water every 2-3 weeks',
          'Tolerates low light',
          'Avoid overwatering',
          'Wipe leaves occasionally',
        ],
      ),
      Plant(
        id: '2',
        name: 'Monstera',
        scientificName: 'Monstera deliciosa',
        category: 'Indoor',
        imageEmoji: '🍃',
        wateringFrequencyDays: 7,
        sunlight: 'Bright Indirect',
        difficulty: 'Medium',
        description: 'Popular tropical plant with distinctive split leaves.',
        careTips: [
          'Water when top soil is dry',
          'Needs bright indirect light',
          'Mist leaves regularly',
          'Provide support for climbing',
        ],
      ),
      Plant(
        id: '3',
        name: 'Pothos',
        scientificName: 'Epipremnum aureum',
        category: 'Indoor',
        imageEmoji: '🌱',
        wateringFrequencyDays: 7,
        sunlight: 'Low to Bright Indirect',
        difficulty: 'Easy',
        description: 'Versatile trailing plant that purifies air.',
        careTips: [
          'Water weekly',
          'Adapts to various light conditions',
          'Trim to encourage bushiness',
          'Easy to propagate',
        ],
      ),
      Plant(
        id: '4',
        name: 'Peace Lily',
        scientificName: 'Spathiphyllum',
        category: 'Indoor',
        imageEmoji: '🌸',
        wateringFrequencyDays: 5,
        sunlight: 'Low to Medium',
        difficulty: 'Easy',
        description: 'Elegant plant with white flowers and air-purifying qualities.',
        careTips: [
          'Keep soil moist',
          'Droops when thirsty',
          'Prefers humid environment',
          'Remove dead flowers',
        ],
      ),
      Plant(
        id: '5',
        name: 'Aloe Vera',
        scientificName: 'Aloe barbadensis',
        category: 'Succulent',
        imageEmoji: '🌵',
        wateringFrequencyDays: 21,
        sunlight: 'Bright Direct',
        difficulty: 'Easy',
        description: 'Medicinal succulent with healing gel in its leaves.',
        careTips: [
          'Water deeply but infrequently',
          'Needs bright light',
          'Well-draining soil essential',
          'Gel can treat minor burns',
        ],
      ),
      Plant(
        id: '6',
        name: 'Fiddle Leaf Fig',
        scientificName: 'Ficus lyrata',
        category: 'Indoor',
        imageEmoji: '🌳',
        wateringFrequencyDays: 7,
        sunlight: 'Bright Indirect',
        difficulty: 'Hard',
        description: 'Trendy plant with large, violin-shaped leaves.',
        careTips: [
          'Consistent watering schedule',
          'Rotate for even growth',
          'Sensitive to changes',
          'Clean leaves regularly',
        ],
      ),
    ];
  }
}
