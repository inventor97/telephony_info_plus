package uz.uzinfocom.telephony_info_plus

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject

/** TelephonyInfoPlusPlugin */
class TelephonyInfoPlusPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "telephony_info_plus")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    if (call.method == "getSimInfos") {
      result.success(getSimInfo())
    } else {
      result.notImplemented()
    }
  }

  @SuppressLint("MissingPermission")
  private fun getSimInfo(): String {
    val simList = JSONArray()
    val subscriptionManager = context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager
    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

    val subscriptionInfoList = subscriptionManager.activeSubscriptionInfoList

    if (subscriptionInfoList != null) {
      for (info in subscriptionInfoList) {
        val simInfo = JSONObject()
        simInfo.put("provider_name", info?.carrierName.toString())
        simInfo.put("provider_country_code", info.mcc)
        simInfo.put("mobile_network_code", info.mnc)
        simInfo.put("is_sim_roaming", info.dataRoaming == SubscriptionManager.DATA_ROAMING_ENABLE)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
          simInfo.put("is_esim", info.isEmbedded)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
          val subTelephonyManager = telephonyManager.createForSubscriptionId(info.subscriptionId)
          simInfo.put("is_active", subTelephonyManager.simState == TelephonyManager.SIM_STATE_READY)
          simInfo.put("signal_type", getNetworkTypeString(subTelephonyManager.dataNetworkType))

          val cellInfoList = subTelephonyManager.allCellInfo
          if (cellInfoList.isNotEmpty()) {
            val signalStrength =
              if (cellInfoList.size > 1) cellInfoList[info.simSlotIndex].cellSignalStrength.dbm else cellInfoList.first().cellSignalStrength.dbm
            if (telephonyManager.signalStrength?.gsmSignalStrength != null) simInfo.put("signal_strength", signalStrength)
          }
        }

        simList.put(simInfo)
      }
    }

    return simList.toString()
  }

  private fun getNetworkTypeString(networkType: Int): String {
    return when (networkType) {
      TelephonyManager.NETWORK_TYPE_GPRS -> "GPRS"
      TelephonyManager.NETWORK_TYPE_EDGE -> "EDGE"
      TelephonyManager.NETWORK_TYPE_UMTS -> "UMTS"
      TelephonyManager.NETWORK_TYPE_CDMA -> "CDMA"
      TelephonyManager.NETWORK_TYPE_EVDO_0 -> "EVDO_0"
      TelephonyManager.NETWORK_TYPE_EVDO_A -> "EVDO_A"
      TelephonyManager.NETWORK_TYPE_1xRTT -> "1xRTT"
      TelephonyManager.NETWORK_TYPE_HSPA -> "HSPA"
      TelephonyManager.NETWORK_TYPE_HSDPA -> "HSDPA"
      TelephonyManager.NETWORK_TYPE_HSUPA -> "HSUPA"
      TelephonyManager.NETWORK_TYPE_IDEN -> "IDEN"
      TelephonyManager.NETWORK_TYPE_EVDO_B -> "EVDO_B"
      TelephonyManager.NETWORK_TYPE_LTE -> "LTE"
      TelephonyManager.NETWORK_TYPE_EHRPD -> "EHRPD"
      TelephonyManager.NETWORK_TYPE_HSPAP -> "HSPAP"
      TelephonyManager.NETWORK_TYPE_GSM -> "GSM"
      TelephonyManager.NETWORK_TYPE_TD_SCDMA -> "SCDMA"
      TelephonyManager.NETWORK_TYPE_IWLAN -> "IWLAN"
      TelephonyManager.NETWORK_TYPE_NR -> "NR (5G)"
      else -> "Unknown"
    }
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
