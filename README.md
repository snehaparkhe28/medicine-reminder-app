# Medicine-Reminder
Medicine Reminder is a Flutter &amp; Dart application that allows users to add medicines with dosage and time, receive scheduled reminders, and view a neatly sorted daily medicine list with a clean, user-friendly UI.

 Features
 Core Features
Add Medicines: Easily add medicines with name, dose, and time

Daily Reminders: Get notified at scheduled times every day

Medicine List: View all medicines sorted by time

Mark as Taken: Toggle medicine status with one tap

Delete Medicines: Remove medicines when no longer needed

Empty State: Beautiful placeholder when no medicines are added

Form Validation: Prevents saving empty forms

 Smart Notifications
Instant Notifications: Test notifications to verify setup

Daily Scheduling: Automatic daily reminders at specified times

Action Buttons:

 Mark as Taken - Dismiss notification and mark medicine

 Snooze - Reschedule reminder for 10 minutes later

Custom Sounds & Vibration: Distinctive notification patterns

Permission Handling: Automatic permission requests

 Design & UI
Modern Interface: Clean, intuitive Material Design

Color Scheme:

Primary: Teal (#008080)

Accent/Buttons: Orange (#FF9800)

Responsive Layout: Works on all screen sizes

Card-Based Design: Each medicine in a beautiful card

Time Indicators: Visual time circles with AM/PM format

 Technical Stack
Frameworks & Libraries
Flutter - UI framework
Dart - Programming language
Provider - State management
Awesome Notifications - Notification system
Shared Preferences - Local storage
Intl - Internationalization support

Architecture
Clean Architecture: Separation of concerns
MVVM Pattern: Model-View-ViewModel structure
Repository Pattern: Data abstraction layer
Dependency Injection: Provider for state management


lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart          # App theme & colors
│   └── utils/
│       └── awesome_notifications.dart # Notification service
├── data/
│   ├── models/
│   │   └── medicine.dart           # Medicine data model
│   └── repositories/
│       └── medicine_repository.dart # Data operations & storage
├── presentation/
│   ├── pages/
│   │   ├── home_page.dart          # Main screen
│   │   └── add_medicine_page.dart  # Add medicine form
│   └── widgets/
│       └── medicine_card.dart      # Medicine list item
└── main.dart                       # App entry point



Installation

Clone the repository

git clone https://github.com/yourusername/medicine-reminder.git
cd medicine-reminder

Install dependencies
flutter pub get

Run the app
flutter run
