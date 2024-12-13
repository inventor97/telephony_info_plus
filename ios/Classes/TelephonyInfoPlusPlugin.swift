import Flutter
import UIKit
import CoreTelephony


public class TelephonyInfoPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "telephony_info_plus", binaryMessenger: registrar.messenger())
    let instance = TelephonyInfoPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
          switch call.method {
          case "getSimInfos":
              let simInfo = getSimInfo()
              if(simInfo != "") {result(simInfo)}
          default:
              result(FlutterMethodNotImplemented)
          }
      }
}

private func getSimInfo() -> String?  {
    let networkInfo = CTTelephonyNetworkInfo()
    var simInfo: [[String: Any]] = []



    if #available(iOS 12.0, *) {
        for (service, carrier) in networkInfo.serviceSubscriberCellularProviders ?? [:] {
            let radio = networkInfo.serviceCurrentRadioAccessTechnology?[service]

            var info: [String: Any] = [:]
            info["provider_name"] = (carrier.carrierName == "--" || carrier.carrierName == nil) ? nil : carrier.carrierName
            info["provider_country_code"] = carrier.isoCountryCode
            info["mobile_network_code"] = carrier.mobileNetworkCode
            info["mobile_country_code"] = carrier.mobileCountryCode
            info["is_sim_roaming"] = carrier.allowsVOIP
            info["is_network_active"] = radio != nil
            info["is_esim"] = carrier.mobileNetworkCode?.isEmpty ?? true


            if #available(iOS 14.1, *) {
                switch radio {
                case CTRadioAccessTechnologyGPRS: info["signal_type"] = "GPRS"
                case CTRadioAccessTechnologyEdge: info["signal_type"] = "EDGE"
                case CTRadioAccessTechnologyWCDMA: info["signal_type"] = "UMTS"
                case CTRadioAccessTechnologyHSDPA: info["signal_type"] = "HSDPA"
                case CTRadioAccessTechnologyHSUPA: info["signal_type"] = "HSUPA"
                case CTRadioAccessTechnologyCDMA1x: info["signal_type"] = "1xRTT"
                case CTRadioAccessTechnologyCDMAEVDORev0: info["signal_type"] = "EVDO_0"
                case CTRadioAccessTechnologyCDMAEVDORevA: info["signal_type"] = "EVDO_A"
                case CTRadioAccessTechnologyCDMAEVDORevB: info["signal_type"] = "EVDO_B"
                case CTRadioAccessTechnologyeHRPD: info["signal_type"] = "EHRPD"
                case CTRadioAccessTechnologyLTE: info["signal_type"] = "LTE"
                case CTRadioAccessTechnologyNRNSA, CTRadioAccessTechnologyNR: info["signal_type"] = "5G"
                default: info["signal_type"] = "Unknown"
                }
            } else {
                info["signal_type"] = "Unknown"
            }

            simInfo.append(info)
        }
    } else {
        simInfo.append(["error": "iOS version not supported."])
    }

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: simInfo, options: [])
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            return jsonString
        } else {
            return ""
        }
    } catch {
        return ""
    }
}