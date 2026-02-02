# Multi-Screen Navigation in Flutter

## Project Overview

This project demonstrates multi-screen navigation in Flutter using the Navigator class and named routes. The implementation showcases how to navigate between multiple screens, pass data between screens, and manage the navigation stack effectively.

## Navigation Setup

### Route Configuration

The app uses named routes defined in `main.dart`:

```dart
routes: {
  '/': (context) => const MyHomePage(title: 'Hot Reload & Debug Demo'),
  '/navigation-home': (context) => const HomeScreen(),
  '/second': (context) => const SecondScreen(),
  '/third': (context) => const ThirdScreen(),
},
```

### Navigation Methods Used

1. **Navigator.pushNamed()** - Navigate to a new screen
2. **Navigator.pop()** - Return to the previous screen
3. **Navigator.pushNamedAndRemoveUntil()** - Navigate and clear the stack

## Screen Implementation

### 1. Home Screen (`home_screen.dart`)

The starting point of our navigation demo with two navigation options:

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Navigation without arguments
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('Go to Second Screen'),
            ),
            // Navigation with arguments
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  '/second', 
                  arguments: 'Hello from Home Screen! 👋'
                );
              },
              child: const Text('Go to Second Screen (with message)'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 2. Second Screen (`second_screen.dart`)

Demonstrates receiving arguments and further navigation:

```dart
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from the previous screen
    final message = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display message if passed
            if (message != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(message),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              child: const Text('Go to Third Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 3. Third Screen (`third_screen.dart`)

Shows advanced navigation stack management:

```dart
class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Screen'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Standard back navigation
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Second Screen'),
            ),
            // Clear stack and go to home
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/navigation-home',
                  (route) => false,
                );
              },
              child: const Text('Back to Home (Clear Stack)'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Key Features Implemented

### 1. Named Routes
- Clean and maintainable route management
- Easy to reference and modify routes
- Centralized route configuration

### 2. Data Passing Between Screens
- Using `arguments` parameter in `Navigator.pushNamed()`
- Retrieving arguments with `ModalRoute.of(context)?.settings.arguments`
- Type-safe argument handling

### 3. Navigation Stack Management
- **Navigator.push()** - Adds screen to stack
- **Navigator.pop()** - Removes current screen from stack
- **Navigator.pushNamedAndRemoveUntil()** - Clears stack and navigates

### 4. User Experience Features
- Visual feedback with different colored app bars
- Clear navigation buttons with descriptive text
- Message display when data is passed between screens
- Multiple navigation options from each screen

## Navigation Flow

```
Main App Home
    ↓
Navigation Home Screen
    ↓
Second Screen (with/without message)
    ↓
Third Screen
    ↓
Back to Navigation Home (stack cleared)
```

### Home Screen
- Blue-themed screen with navigation options
- Two buttons: one for simple navigation, one with message passing

### Second Screen  
- Purple-themed screen showing received message (if any)
- Options to go back or continue to third screen

### Third Screen
- Orange-themed screen with advanced navigation options
- Demonstrates stack clearing functionality

## How Navigator Manages Screen Stack

The Navigator in Flutter manages screens using a **stack data structure**:

1. **Push Operation**: When navigating to a new screen, it's pushed onto the top of the stack
2. **Pop Operation**: When going back, the current screen is popped from the stack
3. **Stack Persistence**: The stack maintains the history of screens for back navigation
4. **Memory Management**: Screens are kept in memory until popped or cleared

### Stack Example:
```
[Third Screen]     ← Current (top of stack)
[Second Screen]    ← Previous
[Home Screen]      ← Initial
[Main App]         ← Root (bottom of stack)
```

## Benefits of Named Routes in Larger Applications

### 1. **Maintainability**
- Centralized route management in one location
- Easy to update route paths across the entire app
- Clear separation of navigation logic

### 2. **Scalability**
- Easy to add new routes without modifying existing screens
- Supports complex navigation patterns
- Can implement route guards and middleware

### 3. **Code Organization**
- Clean and readable navigation code
- Consistent navigation patterns across the app
- Better debugging and testing capabilities

### 4. **Deep Linking Support**
- Named routes work well with URL-based navigation
- Easier to implement web and mobile deep linking
- Better integration with navigation packages

### 5. **Argument Passing**
- Structured way to pass data between screens
- Type-safe argument handling
- Clear data flow documentation

## Testing the Navigation

1. **Run the app**: `flutter run`
2. **Navigate to Navigation Demo**: Tap "Multi-Screen Navigation Demo" from main screen
3. **Test basic navigation**: Use "Go to Second Screen" button
4. **Test with arguments**: Use "Go to Second Screen (with message)" button
5. **Test deeper navigation**: Go to Third Screen from Second Screen
6. **Test stack management**: Use "Back to Home (Clear Stack)" to see stack clearing

## Technical Implementation Details

### Route Registration
```dart
MaterialApp(
  initialRoute: '/',
  routes: {
    '/navigation-home': (context) => const HomeScreen(),
    '/second': (context) => const SecondScreen(),
    '/third': (context) => const ThirdScreen(),
  },
)
```

### Navigation with Arguments
```dart
Navigator.pushNamed(
  context, 
  '/second', 
  arguments: 'Hello from Home Screen! 👋'
);
```

### Argument Retrieval
```dart
final message = ModalRoute.of(context)?.settings.arguments as String?;
```

### Stack Management
```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/navigation-home',
  (route) => false, // Remove all previous routes
);
```

This implementation provides a solid foundation for understanding Flutter navigation patterns and can be extended for more complex navigation requirements in larger applications.