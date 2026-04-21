# Flutter Dio 5.4.0 Research Project

## Overview
This repository contains a learning project dedicated to studying the **Dio 5.4.0** HTTP client in Flutter. The goal of the project is to demonstrate how Dio can be used as the networking layer in a small but production-oriented mobile application.

The project focuses on:
- configuring Dio as a centralized HTTP client;
- implementing CRUD operations with a REST API;
- handling search, sorting, and filtering;
- covering common edge cases such as timeout and network failures;
- testing business logic and integration with the networking layer;
- collecting basic performance metrics.

## Why Dio
Dio was selected because it provides the following features out of the box:
- global configuration;
- interceptors;
- request cancellation;
- timeout handling;
- `FormData`;
- file upload/download;
- custom adapters;
- transformers.

This makes Dio a strong choice for Flutter applications that need more than a minimal HTTP wrapper.

## Tech Stack
- Flutter
- Dart
- Dio 5.4.0
- Provider
- MVVM architecture
- REST API (JSONPlaceholder for demonstration)

## Architecture
The application follows the **MVVM** pattern.

### Layers
- **presentation/** — screens, widgets, and view models;
- **data/** — models, repositories, and API services;
- **core/** — shared networking and utility code.

### Simplified flow
1. UI sends an action to the ViewModel.
2. ViewModel calls the Repository.
3. Repository delegates the request to the Dio-based API service.
4. Dio performs the network request.
5. Response is mapped into models and returned back to the UI.

## Main Features
### A. Basic functionality
- Fetch a list of records from API
- Display records on screen
- Create a new record
- Update an existing record
- Delete a record

### B. Advanced functionality
- Search by title or content
- Sort records
- Filter records by selected parameter
- Refresh list manually

### C. Edge cases
- No internet connection
- Timeout
- Server error handling
- Empty state
- Request cancellation when leaving the screen

## Project Structure
```text
lib/
  core/
    network/
    errors/
  data/
    models/
    services/
    repositories/
  presentation/
    viewmodels/
    screens/
    widgets/
```

## Installation
1. Clone the repository.
2. Run package installation:

```bash
flutter pub get
```

3. Start the application:

```bash
flutter run
```

## Dependency Setup
In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: 5.4.0
  provider: ^6.1.2
```

## Example Dio Setup
```dart
final dio = Dio(
  BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  ),
);
```

## Testing
The repository should include:
- **Unit tests** for ViewModel and business logic;
- **Integration tests** for screen flow and networking behavior.

### Suggested unit tests
- successful loading of posts;
- search filtering logic;
- sorting logic;
- error state propagation;
- empty response handling.

### Suggested integration tests
- list screen opens correctly;
- search works end-to-end;
- network error state is shown to the user.

## Performance Measurements
The project should measure:
- application initialization time;
- APK size impact;
- RAM / CPU usage during data loading.

## Screenshots
Add screenshots of:
- main list screen;
- create/edit screen;
- error state screen;
- search/filter usage.

## Repository Workflow
Recommended branch model:
- `main` — stable branch
- `develop` — development branch
- `feature/*` — new features
- `bugfix/*` — fixes

## Commit Strategy
Recommended commit examples:
- `init flutter project`
- `add dio setup`
- `implement post repository`
- `add search and sorting`
- `add unit tests`
- `fix error state handling`

## Production Notes
Dio is especially appropriate when the project needs:
- interceptors for auth and logging;
- centralized error handling;
- file transfer support;
- more flexible request management than `package:http`.

For strict typed REST APIs, Dio is often combined with packages such as `retrofit` and `json_serializable`.
