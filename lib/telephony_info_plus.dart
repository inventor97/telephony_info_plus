
import 'telephony_info_plus_platform_interface.dart';

class TelephonyInfoPlus {
  Future<List<TelephonyInfo>?> getSimInfos() {
    return TelephonyInfoPlusPlatform.instance.getSimInfos();
  }
}
