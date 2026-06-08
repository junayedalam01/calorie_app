# Calorie Tracker App (Flutter)

A Healthify-style calorie tracking Android app built with Flutter.

## Features
- Calorie ring with daily goal tracking
- 40 Indian foods database
- Macro tracking (Protein, Carbs, Fat)
- Meal slots (Breakfast, Lunch, Dinner, Snacks)
- Water intake tracker
- Swipe to delete food entries
- Persistent daily storage (data saved locally)
- Custom calorie goal settings

## Setup (One Time)

### 1. Install Flutter
- Download from https://flutter.dev/docs/get-started/install
- Follow Android setup (install Android Studio + SDK)
- Run `flutter doctor` — fix any issues it shows

### 2. Add `provider` dependency
The pubspec.yaml already lists it. Just run:

```bash
flutter pub get
```

> Note: `provider` package is missing from pubspec.yaml intentionally for you to add:
> Under `dependencies:` add:
> ```yaml
>   provider: ^6.1.1
> ```

### 3. Build APK

```bash
cd calorie_app
flutter pub get
flutter build apk --release
```

APK will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 4. Install on your phone
- Enable "Install from unknown sources" in Android settings
- Transfer the APK to your phone and tap to install
- OR: `flutter install` with phone connected via USB

## Project Structure
```
lib/
  main.dart              # App entry point
  models/
    food.dart            # Food + LogEntry models + 40-item database
    app_state.dart       # State management + local storage
  screens/
    home_screen.dart     # Main dashboard
    search_screen.dart   # Food search + add
    settings_screen.dart # Goal settings
  widgets/
    calorie_ring.dart    # Circular progress ring
    macro_bar.dart       # Macro breakdown bars
    meal_section.dart    # Meal group cards
    water_tracker.dart   # Water intake tracker
```

## Customization
- Add more foods: edit `foodDatabase` list in `lib/models/food.dart`
- Change default goal: edit `_calorieGoal = 2000` in `app_state.dart`
- Change color: replace `Color(0xFF1A9E6B)` with any hex color
# calorie_app
