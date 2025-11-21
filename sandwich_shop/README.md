# Sandwich Shop

A Flutter application for ordering sandwiches with customizable options and quantity management.

## Description

This Flutter app provides a User Interface (UI) for customers to order sandwiches. Users can select sandwich size (footlong or six-inch), choose bread type, specify quantity, and add custom notes to their orders. The app also features a clean UI real-time order updates and visual feedback.

### Key Features

- **Sandwich Size Selection**: Toggle between footlong and six-inch options
- **Bread Type Selection**: Choose from white, wheat, or wholemeal bread
- **Quantity Management**: Add/remove sandwiches with configurable maximum limits
- **Order Notes**: Add custom instructions (e.g., "no onions")
- **Visual Order Display**: Real-time sandwich emoji display based on quantity
- **Responsive UI**: Clean Material Design interface with custom styling

## Installation and Setup

### Prerequisites

- **Flutter SDK** (>=2.17.0 <4.0.0)
- **Git** for version control
- **IDE**: Visual Studio Code (recommended)

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/manighahrmani/sandwich_shop.git
   cd sandwich_shop
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```
# Sandwich Shop

A small Flutter application demonstrating a simple sandwich-ordering UI and business logic. The app is intended as an educational/assignment project and shows how to combine state management, widgets, and small repositories in a clean Material UI.

## Quick description

Users can:
- Toggle sandwich size between six-inch and footlong
- Choose a bread type (White, Wheat, Multigrain)
- Increment/decrement the order quantity (bounded by a configurable maximum)
- Add order notes (e.g., "no onions")
- See a live order summary that updates as they interact with the UI

This project is implemented with a small `OrderRepository` for order state (quantity and limits) and a single `OrderScreen` in `lib/main.dart` that contains the UI.

## Features

- Sandwich size toggle (six-inch / footlong)
- Bread type selection via dropdown (White, Wheat, Multigrain)
- Quantity management with Add / Remove buttons and a configurable max limit
- Notes text field for special instructions
- Live visual summary using sandwich emoji

## Tech stack

- Flutter (Dart)
- Minimal dependencies: `cupertino_icons`

See `pubspec.yaml` for SDK constraints and version info (this project targets Dart SDK >=2.17.0 <4.0.0).

## Installation and setup

Prerequisites

- Flutter SDK (follow the official install guide: https://flutter.dev/docs/get-started/install)
- Git (to clone the repo)
- An editor such as Visual Studio Code or Android Studio

Clone and prepare

```bash
git clone https://github.com/Kafanga365/sandwich_shop.git
cd sandwich_shop
flutter pub get
```

Verify your Flutter setup

```bash
flutter doctor
```

Run the app

- To run on the default connected device (or simulator/emulator):

```bash
flutter run
```

- To run on the web (Chrome):

```bash
flutter run -d chrome
```

Notes

- The top-level `App` (in `lib/main.dart`) constructs `OrderScreen(maxQuantity: 5)`, so the shipped app uses a maximum of 5 sandwiches. The `OrderScreen` widget itself has a `maxQuantity` default of 10 if constructed without an explicit value.

## Usage

Open the app and you'll see a simple order UI:

1. Use the size switch to select six-inch or footlong. The order summary will mention the chosen size.
2. Pick a bread type from the dropdown (White, Wheat, Multigrain). The summary displays the selected bread.
3. Press the green "Add" button to increase quantity. Press the red "Remove" button to decrease quantity. Buttons will be disabled when hitting limits (0 or max).
4. Enter optional notes in the text field (example: "no onions"). Notes appear in the summary.
5. The summary shows a live count and a repeated sandwich emoji for a fun visual indication.

## Project structure (important files)

```
lib/
├── main.dart                    # App entry, UI widgets, and OrderScreen
├── repositories/
│   └── order_repository.dart    # Order state and quantity limit logic
└── views/
    └── app_styles.dart          # Simple text styles used across the UI

pubspec.yaml                      # Project metadata & SDK constraints
README.md                         # This file
```

## Tests

If you have tests in the `test/` folder, run them with:

```bash
flutter test
```

If you don't yet have tests, consider adding unit tests for `OrderRepository` (increment/decrement/limits) and widget tests for `OrderScreen` interactions.

Recently added

- A widget test was added to `test/views/widget_test.dart` to verify the behavior of the size `Switch` on the main `OrderScreen`. The test toggles the Switch and asserts the displayed summary updates between `six-inch` and `footlong` correctly.

Run the specific test with:

```bash
flutter test test/views/widget_test.dart
```

## Development notes & possible improvements

- Add persistence (local storage) to keep a running cart across app restarts
- Add total price calculation and menu items with configurable ingredients
- Expand UI to multiple screens (cart, checkout)
- Add more robust state management (Provider, Riverpod, Bloc) if the app grows

## Contributing

Contributions are welcome. Please open an issue or a pull request with a short description of the change and reasoning.

## Contact

If you need to reach me about this project, email: up2198300@myport.ac.uk

---

Small educational project — feel free to adapt and extend.
