# Plant Care Pulse - Project Structure

## Overview
A real, working plant care application that demonstrates Flutter concepts through practical features users would actually use.

## Directory Structure

```
PlantCarePulse/
├── lib/
│   ├── main.dart                          # App entry with routing
│   ├── models/                            # Data models
│   │   ├── plant.dart                     # Plant model + sample data
│   │   └── user_plant.dart                # User's plant instance
│   └── screens/                           # Feature screens
│       ├── home/
│       │   └── main_home_screen.dart      # Home with bottom nav
│       ├── plants/
│       │   ├── plant_library_screen.dart  # Browse & discover
│       │   ├── my_plants_screen.dart      # User's collection
│       │   ├── add_plant_screen.dart      # Add plant form
│       │   └── plant_detail_screen.dart   # Plant info page
│       ├── care/
│       │   └── care_schedule_screen.dart  # Care tasks
│       └── profile/
│           └── profile_screen.dart        # Settings & profile
├── pubspec.yaml                           # Dependencies
└── README.md                              # Documentation
```

## Features & Flutter Concepts

### 1. Home Dashboard (`main_home_screen.dart`)
**Concepts**: StatefulWidget, Bottom Navigation, Widget Composition
- Bottom navigation bar (4 tabs)
- Quick action cards
- Today's tasks list
- Care tips section
- Floating action button

### 2. Plant Library (`plant_library_screen.dart`)
**Concepts**: ListView, GridView, Filtering, State Management
- Toggle between grid and list views
- Horizontal scrolling category filter
- Dynamic filtering
- Reusable card widgets

### 3. My Plants (`my_plants_screen.dart`)
**Concepts**: State Management, Interactive Widgets, Conditional Rendering
- Display user's plant collection
- Water tracking with timestamps
- Alert banner for plants needing water
- Interactive water buttons
- Empty state handling

### 4. Add Plant Form (`add_plant_screen.dart`)
**Concepts**: Forms, Validation, User Input, Controllers
- Form validation
- Text input fields
- Horizontal scrolling plant selector
- Date picker
- Form submission with loading state

### 5. Plant Detail (`plant_detail_screen.dart`)
**Concepts**: Navigation with Arguments, Rich Content Display
- Receive plant data via navigation
- Display detailed information
- Custom stat chips
- Care tips list
- Call-to-action button

### 6. Care Schedule (`care_schedule_screen.dart`)
**Concepts**: ListView, Checkboxes, State Updates
- Organized task list
- Interactive checkboxes
- Task completion tracking
- Grouped by time periods

### 7. Profile (`profile_screen.dart`)
**Concepts**: Settings UI, List Tiles, Cards
- User information display
- Statistics cards
- Settings list
- Navigation to sub-pages

## Data Models

### Plant Model
```dart
- id, name, scientificName
- category, imageEmoji
- wateringFrequencyDays
- sunlight, difficulty
- description, careTips[]
```

### UserPlant Model
```dart
- id, plant reference
- nickname, location
- dateAdded, lastWatered
- notes
- Computed: nextWateringDate, needsWatering
```

## Navigation Routes

```
/ → MainHomeScreen (with bottom nav)
  ├─ Home Tab
  ├─ Plant Library Tab
  ├─ My Plants Tab
  └─ Profile Tab

/plant-library → PlantLibraryScreen
/my-plants → MyPlantsScreen
/add-plant → AddPlantScreen
/plant-detail → PlantDetailScreen (with args)
/care-schedule → CareScheduleScreen
/profile → ProfileScreen
```

## Widget Hierarchy Example

```
MainHomeScreen (StatefulWidget)
└── Scaffold
    ├── body: _screens[_currentIndex]
    │   └── HomeTab (StatelessWidget)
    │       └── Scaffold
    │           ├── AppBar
    │           └── SingleChildScrollView
    │               └── Column
    │                   ├── Welcome Banner (Container)
    │                   ├── Quick Actions (Row of Cards)
    │                   ├── Today's Tasks (List of Cards)
    │                   └── Care Tips (List of Cards)
    └── BottomNavigationBar
```

## Key Patterns Used

### 1. Stateless vs Stateful
- **Stateless**: Display-only widgets (cards, tiles, info)
- **Stateful**: Interactive widgets (forms, checkboxes, navigation)

### 2. Widget Composition
- Small, reusable widgets
- Private widgets (prefixed with `_`) for internal use
- Public widgets for shared components

### 3. State Management
- `setState()` for local state
- Controllers for form inputs
- Computed properties for derived data

### 4. Navigation
- Named routes in main.dart
- `Navigator.pushNamed()` for navigation
- `ModalRoute.of(context).settings.arguments` for data passing

### 5. Responsive Design
- MediaQuery for screen dimensions
- Flexible layouts with Expanded/Flexible
- Scrollable views for overflow content

## Running the App

```bash
cd PlantCarePulse
flutter pub get
flutter run
```

## Development Tips

1. **Hot Reload**: Press `r` in terminal for quick updates
2. **Hot Restart**: Press `R` for full restart
3. **Debug**: Use `debugPrint()` for logging
4. **Inspect**: Use Flutter DevTools for widget inspection

## Next Steps

- Add local storage (shared_preferences)
- Implement notifications
- Add image support
- Create onboarding flow
- Add search functionality
- Implement data persistence

---

This structure demonstrates real-world Flutter app organization while teaching core concepts through practical implementation.
