import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'telephony_info_plus_method_channel.dart';

abstract class TelephonyInfoPlusPlatform extends PlatformInterface {
  TelephonyInfoPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static TelephonyInfoPlusPlatform _instance = MethodChannelTelephonyInfoPlus();

  static TelephonyInfoPlusPlatform get instance => _instance;

  static set instance(TelephonyInfoPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<TelephonyInfo>?> getSimInfos() => _instance.getSimInfos();
}

class TelephonyInfo {
  final bool? isActive;
  final bool? isESim;
  final bool? isRoamingActive;
  final String? mobileNetworkCode;
  final String? providerName;
  final String? signalStrength;
  final String? providerCountryCode;
  final String? signalType;

  TelephonyInfo({
    this.isActive,
    this.isESim,
    this.isRoamingActive,
    this.mobileNetworkCode,
    this.providerName,
    this.signalStrength,
    this.providerCountryCode,
    this.signalType,
  });

  factory TelephonyInfo.fromJson(Map<String, dynamic> json) => TelephonyInfo(
    isActive: json["is_active"],
    isESim: json["is_esim"],
    isRoamingActive: json["is_sim_roaming"],
    mobileNetworkCode: json["mobile_network_code"]?.toString(),
    providerName: json["provider_name"]?.toString(),
    signalStrength: json["signal_strength"]?.toString(),
    providerCountryCode: json["provider_country_code"]?.toString(),
    signalType: json["signal_type"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "is_active": isActive,
    "is_esim": isESim,
    "is_sim_roaming": isRoamingActive,
    "mobile_network_code": mobileNetworkCode,
    "provider_name": providerName,
    "signal_strength": signalStrength,
    "provider_country_code": providerCountryCode,
    "signal_type": signalType,
  };

  @override
  String toString() {
    return "provider_name: $providerName\n"
        "mobile_network_code: $mobileNetworkCode\n"
        "provider_country_code: $providerCountryCode\n"
        "signal_strength: $signalStrength\n"
        "signal_type: $signalType\n"
        "is_esim: $isESim\n"
        "is_sim_roaming: $isRoamingActive\n"
        "is_active: $isActive";
  }
}
