# Telephony Info Plus Plugin

A Flutter plugin to retrieve detailed SIM information, supporting the Android platform. The plugin provides various details about the SIM cards on a device, including:

- `providerName`
- `mcc` (Mobile Country Code)
- `mnc` (Mobile Network Code)
- `isSimRoaming`
- `isESim`
- `signalType`
- `signalStrength`

## Features

### Android
- Returns all SIM information for devices running **Android 6.0 (API level 23)** or higher.
- `signalType` and `signalStrength` are available only on Android 10+ due to API limitations.
- Requires the following permissions in the `AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.READ_PHONE_STATE" />
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  ```
- **Important**: You must request `READ_PHONE_STATE` and `ACCESS_FINE_LOCATION` permissions at runtime before using the plugin. Example:
  ```dart
  import 'package:permission_handler/permission_handler.dart';

  Future<void> requestPermissions() async {
    await [
      Permission.phone,
      Permission.location
    ].request();
  }
  ```

### iOS
Due to iOS restrictions, this plugin does not support iOS 16+ and works only on Android devices. For more details, refer to [Apple Documentation](https://developer.apple.com/documentation/coretelephony/ctcarrier).

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  telephony_info_plus: ^0.0.1
```

Then, run:

```bash
flutter pub get
```

## Usage

Import the plugin in your Dart code:

```dart
import 'package:telephony_plus/telephony_plus.dart';
```

Retrieve the SIM information:

```dart
List<TelephonyInfo>? getSimInfo() async {
  try {
    return await _telephonyPlusPlugin.getSimInfos();
  } catch (e) {
    print(e);
  }
}
```

## Platform-Specific Notes

### Android
- **API Level**: Full functionality is available only on devices running Android 6.0 or newer.
- **Multiple SIMs**: For devices with multiple SIM cards, the plugin returns an array of SIM information.

## Limitations
- `signalType` and `signalStrength` are supported only on Android 10+.
- Due to iOS restrictions, this plugin does not support iOS 16+ and works only on Android devices.

## License

MIT License. See [LICENSE](./LICENSE) for details.

