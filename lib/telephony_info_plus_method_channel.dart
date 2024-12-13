import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'telephony_info_plus_platform_interface.dart';

class MethodChannelTelephonyInfoPlus extends TelephonyInfoPlusPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('telephony_info_plus');

  @override
  Future<List<TelephonyInfo>?> getSimInfos() async {
    try {
      final result = await methodChannel.invokeMethod<String>('getSimInfos');
      if (result == null) return null;
      final rez = await jsonDecode(result);
      return List<TelephonyInfo>.from(rez.map((json) => TelephonyInfo.fromJson(json)) ?? []);
    } on PlatformException catch (e) {
      throw ("Platform Exception: ${e.message}");
    } catch (e) {
      throw ('error ${e.toString()}');
    }
  }
}
