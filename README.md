# ⚡ E-Bill Estimator

A Flutter mobile application for estimating monthly electricity bills based on TNB's tiered block pricing system.

## 📱 Features

- Calculate monthly electricity charges based on tiered block pricing
- Apply rebate percentage (0% – 5%) using an interactive slider
- Save, view, edit, and delete billing records locally
- Clean and intuitive grey-themed UI

## 🧮 Pricing Blocks

| Block | Units (kWh) | Rate (sen/kWh) |
|-------|-------------|----------------|
| 1 | 1 – 200 | 21.8 |
| 2 | 201 – 300 | 33.4 |
| 3 | 301 – 600 | 51.6 |
| 4 | 601 – 1000 | 54.6 |

## 📂 Project Structure

```
electricity_bill_estimator/
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml
├── assets/
│   └── images/
│       └── profile.jpg
├── lib/
│   ├── db/
│   │   └── database_helper.dart
│   ├── models/
│   │   └── bill_record.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── list_screen.dart
│   │   ├── detail_screen.dart
│   │   └── about_screen.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   └── bill_calculator.dart
│   └── main.dart
└── pubspec.yaml
```

## 🛠️ Built With

- [Flutter](https://flutter.dev/) — UI framework
- [sqflite](https://pub.dev/packages/sqflite) — Local SQLite database
- [path](https://pub.dev/packages/path) — Database path helper
- [url_launcher](https://pub.dev/packages/url_launcher) — Clickable URLs
- [intl](https://pub.dev/packages/intl) — Number formatting

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.11.5
- Android Studio or VS Code
- Android device or emulator

### Installation

1. Clone the repository
```bash
git clone https://github.com/MohammedHaydar1/electricity_bill_estimator
```

2. Navigate to the project folder
```bash
cd electricity_bill_estimator
```

3. Install dependencies
```bash
flutter pub get
```

4. Run the app
```bash
flutter run
```

## 📖 How to Use

1. Open the app and select your billing **month** from the dropdown
2. Enter the number of **units used** (1 – 1000 kWh)
3. Drag the **rebate slider** to set your rebate (0% – 5%)
4. Tap **Calculate** to see your total charges and final cost
5. Tap **Save to Database** to store the record
6. Tap the **list icon** (top right) to view all saved records
7. Tap any record to **view details, edit, or delete** it

## 📊 Sample Calculation

| Units | Total Charges | Rebate (5%) | Final Cost |
|-------|--------------|-------------|------------|
| 150 kWh | RM 32.700 | RM 1.635 | RM 31.065 |
| 250 kWh | RM 60.300 | RM 3.015 | RM 57.285 |
| 467 kWh | RM 163.172 | RM 8.159 | RM 155.013 |

## 👤 Developer

- **Name:** Mohammed Haydar Othman
- **Student ID:** QIU23-0421
- **Course:** Mobile Technology and Devlopment ICT602

## 📄 License

© 2026 Mohammed Haydar Othman. All rights reserved.