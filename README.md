# 🧩 Flutter Clean Architecture TDD Template

[![Flutter](https://img.shields.io/badge/Flutter-3.35.xx-blue?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.xx-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)


A **Flutter project template** based on **Clean Architecture** and **Test-Driven Development (TDD)**.  
This repository provides a scalable, maintainable, and modular project structure to help you kickstart new Flutter applications with best practices in mind.

---

## 🚀 Tech Stack

### Framework & Language
- Flutter **3.35.xx**
- Dart **3.9.xx**

### Architecture & State Management
- [Bloc](https://pub.dev/packages/flutter_bloc) – primary state management
- [Flutter Bloc](https://pub.dev/packages/flutter_bloc) - Flutter widgets that make it easy to integrate blocs
- [Provider](https://pub.dev/packages/provider) – data binding
- [getIt](https://pub.dev/packages/get_it) – dependency injection
- [Equatable](https://pub.dev/packages/equatable) – value equality
- [Dartz](https://pub.dev/packages/dartz) - Either Success or Failure Handler
- [flutter_lints](https://pub.dev/packages/flutter_lints) – linting & code style

### Data & API
- [Dio](https://pub.dev/packages/dio) – HTTP client
- [Shared Preferences](https://pub.dev/packages/shared_preferences) – key-value storage

### Utilities
- [flutter_svg](https://pub.dev/packages/flutter_svg) – SVG rendering
- [lottie](https://pub.dev/packages/lottie) – animations
- [url_launcher](https://pub.dev/packages/url_launcher) – external URL launcher
- [package_info_plus](https://pub.dev/packages/package_info_plus) – app versioning

### Testing
- [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) – unit testing
- [mocktail](https://pub.dev/packages/mocktail) – mocking
- [bloc_test](https://pub.dev/packages/bloc_test) – bloc testing utilities

---

## 📂 Project Structure
```text
project_root/
│
├── android/                # Native Android project
├── ios/                    # Native iOS project
├── assets/
│   ├── animations/         # Lottie animations
│   ├── fonts/              # Custom fonts
│   ├── icons/              # App icons
│   ├── images/             # PNG/JPG images
│   └── vectors/            # SVG vector files
│
├── lib/
│   └── main.dart           # Main Program
│   └── src/
│       ├── core/                   
│       │   ├── enums/              # App-wide enumerations
│       │   ├── errors/             # Error handling & exceptions
│       │   ├── extensions/         # Dart extensions
│       │   ├── res/                # Resources (colors, typography, etc.)
│       │   ├── services/           # External services (API, Firebase, etc.)
│       │   ├── shared/             # Shared widgets/components
│       │   ├── usecases/           # Contract Abstraction for usecase pattern
│       │   ├── utils/              # Utility helpers
│       │   └── modules/            # Reusable domain/data modules
│       │       └── sample_module/  
│       │           ├── domain/
│       │           │   ├── entities/
│       │           │   │   └── sample_entity.dart
│       │           │   ├── repositories/
│       │           │   │   └── sample_repository.dart
│       │           │   └── usecases/
│       │           │       └── sample_usecase.dart
│       │           └── data/
│       │               ├── datasources/
│       │               │   └── sample_remote_data_source.dart
│       │               └── repositories/
│       │                   └── sample_repository_impl.dart
│       │
│       └── features/
│           └── feature_a/
│               ├── data/
│               │   ├── datasources/
│               │   │   ├── feature_a_remote_data_source.dart
│               │   │   └── feature_a_local_data_source.dart
│               │   ├── models/
│               │   │   └── feature_a_model.dart
│               │   └── repositories/
│               │       └── feature_a_repository_impl.dart
│               │
│               ├── domain/
│               │   ├── entities/
│               │   │   └── feature_a_entity.dart
│               │   ├── repositories/
│               │   │   └── feature_a_repository.dart
│               │   └── usecases/
│               │       └── get_feature_a_items.dart
│               │
│               └── presentation/
│                   ├── bloc/
│                   │   ├── feature_a_bloc.dart
│                   │   ├── feature_a_event.dart
│                   │   └── feature_a_state.dart
│                   ├── providers/
│                   │   └── feature_a_provider.dart
│                   ├── screens/
│                   │   └── feature_a_screen.dart
│                   ├── shimmer_views/
│                   │   └── feature_a_list_shimmer.dart
│                   ├── views/
│                   │   └── feature_a_list_view.dart
│                   └── widgets/
│                       └── feature_a_card.dart
│
├── test/
│   ├── core/
│   │   └── modules/
│   │       └── sample_module/
│   │           ├── domain/
│   │           │   └── usecases/sample_usecase_test.dart
│   │           └── data/
│   │               └── repositories/sample_repository_impl_test.dart
│   │
│   └── features/
│       └── feature_a/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── feature_a_remote_data_source_test.dart
│           │   ├── models/
│           │   │   └── feature_a_model_test.dart
│           │   └── repositories/
│           │       └── feature_a_repository_impl_test.dart
│           │
│           ├── domain/
│           │   ├── entities/
│           │   │   └── feature_a_entity_test.dart
│           │   ├── repositories/
│           │   │   └── feature_a_repository_test.dart
│           │   └── usecases/
│           │       └── get_feature_a_items_test.dart
│           │
│           └── presentation/
│               └── bloc/
│                   └── feature_a_bloc_test.dart
│
└── pubspec.yaml
```

## 🧪 Testing

This project is set up for **unit testing only**:  
- **Data layer** → datasources, models, repositories  
- **Domain layer** → entities, repositories, usecases  
- **Presentation layer** → bloc only

Run tests with:

```bash
flutter test
```

## 📌 Notes

- Features inside `features/` follow the **data → domain → presentation** pattern.  
- `presentation` includes `bloc`, `providers`, `screens`, `views`, `widgets`, and `shimmer_views`, but **only the bloc layer is unit tested**.  
- Core modules can be added in `lib/src/core/` for reusable code.  
- This template is designed to be scalable for small to enterprise-level applications.  

---

## 🔮 Upcoming Features

Planned updates for this template:

- [ ] **CI/CD Workflow** using GitHub Actions (Flutter analyze + test)  
- [ ] Example implementation of a **core module** (e.g., error handling, app theme)  
- [ ] Pre-configured **Firebase setup guide**  
