# Plant Care Pulse 🌱

A real, working plant care management application built with Flutter. This app demonstrates Flutter concepts through practical, user-facing features.

## Features

### 🏠 Home Dashboard
- Welcome banner with personalized greeting
- Quick action buttons for common tasks
- Today's care tasks overview
- Helpful plant care tips

### 🌿 Plant Discovery
- Browse plant library with grid/list views
- Filter plants by category
- Detailed plant information pages
- Care requirements and tips

### 🪴 My Plants Collection
- Manage your personal plant collection
- Track watering schedules
- Get notifications for plants needing care
- Add custom nicknames and notes

### 📅 Care Schedule
- View upcoming care tasks
- Mark tasks as complete
- Organized by today, tomorrow, and this week

### 👤 Profile & Settings
- View your plant statistics
- Manage app settings
- Access help and support

## Flutter Concepts Demonstrated

This app showcases Flutter concepts in real, practical implementations:

### Stateless vs Stateful Widgets
- **Stateless**: Plant cards, info displays, static content
- **Stateful**: Interactive forms, checkboxes, bottom navigation, watering buttons

### Navigation
- Bottom navigation bar for main sections
- Named routes for screen navigation
- Passing data between screens (plant details)

### Layouts & Scrolling
- GridView for plant library
- ListView for scrollable lists
- SingleChildScrollView for long content
- Horizontal scrolling for categories

### Forms & Input
- Add plant form with validation
- Text fields with controllers
- Date picker integration
- Form submission handling

### State Management
- setState() for local state
- Managing plant collections
- Tracking watering status
- Interactive checkboxes

### Custom Widgets
- Reusable card components
- Custom badges and chips
- Themed buttons and tiles

## Getting Started

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Navigate to the project directory:
```bash
cd PlantCarePulse
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── plant.dart                     # Plant model with sample data
│   └── user_plant.dart                # User's plant instance
└── screens/                           # All app screens
    ├── home/
    │   └── main_home_screen.dart      # Home dashboard with tabs
    ├── plants/
    │   ├── plant_library_screen.dart  # Browse plants
    │   ├── my_plants_screen.dart      # User's plant collection
    │   ├── add_plant_screen.dart      # Add new plant form
    │   └── plant_detail_screen.dart   # Plant information
    ├── care/
    │   └── care_schedule_screen.dart  # Care task schedule
    └── profile/
        └── profile_screen.dart        # User profile & settings
```

## How It Works

### Data Flow
1. Sample plant data is defined in `Plant.getSamplePlants()`
2. Users can browse plants in the library
3. Adding a plant creates a `UserPlant` instance
4. Watering updates the `lastWatered` timestamp
5. UI automatically updates using `setState()`

### Key Features Implementation

**Bottom Navigation**: Uses `StatefulWidget` to track current tab index

**Plant Cards**: Reusable widgets that display plant information consistently

**Watering System**: Calculates next watering date based on plant's frequency

**Forms**: Validates input and provides user feedback

**Responsive UI**: Adapts to different screen sizes and orientations

## Future Enhancements

- Local storage with shared_preferences
- Push notifications for watering reminders
- Plant identification using camera
- Social features and community tips
- Advanced analytics and insights
- Firebase integration for cloud sync

## Learning Resources

This app demonstrates:
- Widget composition and reusability
- State management patterns
- Navigation and routing
- Form handling and validation
- List and grid layouts
- Custom theming
- User interaction patterns

## License

This project is for educational purposes.

---

Built with ❤️ using Flutter
