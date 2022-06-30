package com.golfchannel.reactnative.marketingcloud

import android.app.PendingIntent
import android.os.Build
import com.facebook.react.bridge.*
import com.salesforce.marketingcloud.MCLogListener
import com.salesforce.marketingcloud.MarketingCloudConfig
import com.salesforce.marketingcloud.MarketingCloudSdk
import com.salesforce.marketingcloud.messages.inbox.InboxMessage
import com.salesforce.marketingcloud.notifications.NotificationCustomizationOptions
import com.salesforce.marketingcloud.sfmcsdk.InitializationStatus
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdk
import com.salesforce.marketingcloud.sfmcsdk.SFMCSdkModuleConfig
import java.util.*

class RNMarketingCloud(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  companion object {
    @JvmStatic
    var config: RNMarketingCloudConfig? = null
  }

  override fun getName(): String {
    return "RNMarketingCloud"
  }

  /**
   * Initializes the Salesforce Marketing Cloud SDK.
   */
  @ReactMethod
  fun initializeSDK(promise: Promise) {
    val sdkConfig = if (config?.appId?.isEmpty() == false) config!! else {
      return promise.reject(
        "E_SDK_CONFIG_INVALID",
        "The SDK configuration on the Android side is invalid"
      )
    }

    // Create the notification customization options
    val customizationOptions = NotificationCustomizationOptions.create(
      sdkConfig.notificationIcon, { context, notification ->
        val requestCode = Random().nextInt()
        val intent = sdkConfig.notificationUrlHandler(notification.url)
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M)
          PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE else PendingIntent.FLAG_UPDATE_CURRENT

        PendingIntent.getActivity(context, requestCode, intent, flags)
      }, null
    )

    // Configure the SDK
    SFMCSdk.configure(reactApplicationContext, SFMCSdkModuleConfig.build {
      pushModuleConfig = MarketingCloudConfig.builder().apply {
        setApplicationId(sdkConfig.appId)
        setAccessToken(sdkConfig.accessToken)
        setMarketingCloudServerUrl(sdkConfig.cloudServerURL)
        setSenderId(sdkConfig.senderId)
        setAnalyticsEnabled(sdkConfig.analyticsEnabled)
        setInboxEnabled(sdkConfig.inboxEnabled)
        setNotificationCustomizationOptions(customizationOptions)
      }.build(reactApplicationContext)
    }) {
      when (it.status) {
        InitializationStatus.SUCCESS -> promise.resolve(true)
        InitializationStatus.FAILURE -> promise.resolve(false)
      }
    }
  }

  /**
   * Enables or disables verbose logging within the native Marketing Cloud SDK.
   */
  @ReactMethod
  fun setDebugLoggingEnabled(enabled: Boolean) {
    val level = if (enabled) MCLogListener.DEBUG else MCLogListener.INFO
    MarketingCloudSdk.setLogLevel(level)
  }

  // region Push Notifications

  /**
   * Returns the token used to send push messages to the device.
   */
  @ReactMethod
  fun getDeviceToken(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp {
        val result = it.pushMessageManager.pushToken
        promise.resolve(result)
      }
    }
  }

  /**
   * Returns the profile id currently set on the device.
   */
  @ReactMethod
  fun getProfileId(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp {
        val result = it.moduleIdentity.profileId
        promise.resolve(result)
      }
    }
  }

  /**
   * Sets the profile id for the device's user.
   */
  @ReactMethod
  fun setProfileId(profileId: String) {
    SFMCSdk.requestSdk { sdk ->
      sdk.identity.setProfileId(profileId)
    }
  }

  /**
   * Sets custom profile attributes on the push notification record.
   */
  @ReactMethod
  fun setProfileAttributes(attributes: ReadableMap) {
    SFMCSdk.requestSdk { sdk ->
      val map = attributes.toHashMap().mapValues { it.toString() }
      sdk.identity.setProfileAttributes(map)
    }
  }

  /**
   * Indicates if the push messaging functionality is enabled.
   */
  @ReactMethod
  fun isPushEnabled(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        promise.resolve(mp.pushMessageManager.isPushEnabled)
      }
    }
  }

  /**
   * Enables or disables the push messaging functionality.
   */
  @ReactMethod
  fun setPushEnabled(enabled: Boolean) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        if (enabled) {
          mp.pushMessageManager.enablePush()
        } else {
          mp.pushMessageManager.disablePush()
        }
      }
    }
  }

  // endregion

  // region Push Messaging Inbox

  /**
   * Returns all messages in the inbox.
   */
  @ReactMethod
  fun getAllMessages(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        val messages = mp.inboxMessageManager.messages
        val result = convertMessages(messages)
        promise.resolve(result)
      }
    }
  }

  /**
   * Returns the total number of messages in the inbox.
   */
  @ReactMethod
  fun getAllMessagesCount(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        val result = mp.inboxMessageManager.messageCount
        promise.resolve(result)
      }
    }
  }

  /**
   * Returns the number of unread messages in the inbox.
   */
  @ReactMethod
  fun getUnreadMessagesCount(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        val result = mp.inboxMessageManager.unreadMessageCount
        promise.resolve(result)
      }
    }
  }

  /**
   * Marks a single message as deleted.
   */
  @ReactMethod
  fun markMessageDeleted(messageId: String, promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        mp.inboxMessageManager.deleteMessage(messageId)
        promise.resolve(true)
      }
    }
  }

  /**
   * Marks a single message as read.
   */
  @ReactMethod
  fun markMessageRead(messageId: String, promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        mp.inboxMessageManager.setMessageRead(messageId)
        promise.resolve(true)
      }
    }
  }

  /**
   * Marks all messages in the inbox as deleted.
   */
  @ReactMethod
  fun markAllMessagesDeleted(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        mp.inboxMessageManager.markAllMessagesDeleted()
        promise.resolve(true)
      }
    }
  }

  /**
   * Marks all messages in the inbox as read.
   */
  @ReactMethod
  fun markAllMessagesRead(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        mp.inboxMessageManager.markAllMessagesRead()
        promise.resolve(true)
      }
    }
  }

  /**
   * Reload and refresh Inbox messages from the MarketingCloud server.
   * The underlying request to the server will be throttled such that it will execute at
   * most every 60 seconds.
   */
  @ReactMethod
  fun refreshMessages(promise: Promise) {
    SFMCSdk.requestSdk { sdk ->
      sdk.mp { mp ->
        mp.inboxMessageManager.refreshInbox { result ->
          promise.resolve(result)
        }
      }
    }
  }

  // endregion

  // region Helpers

  /**
   * Converts a list of InboxMessage to a WritableArray so that it can be
   * passed to the JavaScript implementation.
   */
  private fun convertMessages(messages: Iterable<InboxMessage>): WritableArray {
    val result = Arguments.createArray()
    messages.forEach { result.pushMap(convertMessage(it)) }
    return result
  }

  /**
   * Converts a single InboxMessage to a WritableMap that can be passed
   * to the JavaScript implementation.
   */
  private fun convertMessage(message: InboxMessage): WritableMap {
    return Arguments.createMap().apply {
      putString("id", message.id)
      putString("subject", message.subject)
      putString("url", message.url)
      putBoolean("read", message.read)
      putBoolean("deleted", message.deleted)
      putDateEpoch("sendDateEpoch", message.sendDateUtc)
      putDateEpoch("startDateEpoch", message.startDateUtc)
      putDateEpoch("endDateEpoch", message.endDateUtc)
    }
  }

  /**
   * Stores a Date epoch value in the WritableMap.
   */
  private fun WritableMap.putDateEpoch(key: String, date: Date?) {
    if (date == null) { return putNull(key) }
    putDouble(key, date.time.toDouble())
  }

  // endregion
}
