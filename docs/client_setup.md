# Flutter Installation & Dio Client Setup

## 1. Prerequisites

Before setting up the Flutter project, install the following:

* Flutter SDK
* Dart SDK — included with Flutter
* Android Studio
* Android SDK
* Android SDK Platform Tools
* Android Emulator
* Git
* A code editor such as Android Studio or VS Code

Recommended environment:

| Tool           | Recommended   |
| -------------- | ------------- |
| Flutter        | 3.44.5+       |
| Dart           | 3.12.2+       |
| Java           | 21+           |
| Android Studio | Latest stable |
| Android SDK    | API 35+       |
| Git            | Latest stable |

---

## 2. Install Flutter

Download the Flutter SDK from the official Flutter website:

<https://docs.flutter.dev/get-started/install>

Extract Flutter to a suitable location.

For example on Linux:

```bash
mkdir -p ~/development
cd ~/development
```

Extract the Flutter SDK into:

```text
~/development/flutter
```

Add Flutter to the PATH:

```bash
export PATH="$PATH:$HOME/development/flutter/bin"
```

To make this permanent for Bash:

```bash
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

For Zsh:

```bash
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

Verify the installation:

```bash
flutter --version
```

Then run:

```bash
flutter doctor
```

Resolve any issues reported by Flutter Doctor.

---

## 3. Android Studio Setup

Install Android Studio and open:

```text
More Actions → SDK Manager
```

Install:

* Android SDK
* Android SDK Platform
* Android SDK Build-Tools
* Android SDK Command-line Tools
* Android SDK Platform-Tools
* Android Emulator

Then configure an Android Virtual Device:

```text
Android Studio
→ Device Manager
→ Create Virtual Device
```

Select a suitable device, for example:

```text
Pixel 6
```

Select an Android system image and create the emulator.

Verify the emulator:

```bash
flutter devices
```

Example:

```text
emulator-5554 • Android SDK built for x86_64 • android-x64
```

---

## 4. Flutter Project Setup

### Clone the project

Navigate into the project:

```bash
cd Medicare-Plus_Project/client
```

### Get Flutter dependencies

```bash
flutter pub get
```

### Check the project

```bash
flutter doctor
flutter analyze
```

---

## 5. Project Structure

A typical project structure should look like:

```text
client/
├── android/
├── assets/
├── lib/
│   ├── core/
│   │   ├── network/
│   │   │   ├── dio_client.dart
│   │   │   └── api_endpoints.dart
│   │   ├── storage/
│   │   └── utils/
│   │
│   ├── feature/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── patient/
│   │   └── pharmacy/
│   │
│   └── main.dart
│
├── test/
├── pubspec.yaml
└── README.md
```

Keeping the Dio configuration inside `core/network` makes the HTTP layer reusable throughout the application.

---

## 6. Configure API Addresses

Open:

```text
lib/core/network/api_endpoints.dart
```

Example:

```dart
class ApiEndpoints {
  ApiEndpoints._();

  // These is default emulator URL Endpoint.
  // If you want the Connect Physical Device replace URL Endpoint.
  // E.G. http://192.168.1.10
  static const String baseUrl = 'http://10.0.2.2:8080';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String dashbord = '/dashboard';
}
```

### Android Emulator Address

When the backend is running on the development computer, **do not normally use `localhost` or `127.0.0.1` from the Android emulator**.

Use:

```text
10.0.2.2
```

For example:

```dart
static const String baseUrl = 'http://10.0.2.2:8000';
```

This maps the Android emulator's `10.0.2.2` address to the host computer's loopback interface.

### Physical Android Device

For a physical phone connected to the same Wi-Fi network as the development computer, use the computer's LAN IP:

```text
http://192.168.x.x:8000
```

Example:

```dart
static const String baseUrl = 'http://192.168.1.10:8000';
```

The backend must listen on the network interface rather than only `127.0.0.1`.

For FastAPI/Uvicorn:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

---

## 7. Final Verification

Before running the application, execute:

```bash
flutter doctor
flutter pub get
flutter analyze
flutter devices
```

Start the Android emulator:

```bash
flutter emulators
flutter emulators --launch <emulator-id>
```

Finally:

```bash
flutter run
```

Verify that:

1. Flutter starts successfully.
2. Android emulator is detected.
3. Backend is running.
4. Dio can reach the backend.
5. Login API responds successfully.
6. Authentication token is stored securely.
7. Protected API requests include the authorization token.
8. API errors are handled correctly.

---

## Recommended Architecture

```text
Flutter Application
        │
        ▼
Feature Service
(UserService / HealthService / PharmacyService)
        │
        ▼
     DioClient
        │
        ▼
  API Endpoints
        │
        ▼
   Backend Server
        │
        ├── Authentication
        ├── Patient Data
        ├── Health Data
        ├── Reports
        ├── Pharmacy
        └── RAG / AI Services
```

This approach provides a centralized HTTP client, consistent API addresses, reusable authentication handling, and easier switching between emulator, physical-device, and production environments.
