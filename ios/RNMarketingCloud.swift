import Foundation
import MarketingCloudSDK

@objc(RNMarketingCloud)
public class RNMarketingCloud: NSObject {
  @objc public static var config: RNMarketingCloudConfig?

  /// Initializes the Salesforce Marketing Cloud SDK.
  @objc public func initializeSDK(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    guard let config = Self.config, let appId = config.appId, !appId.isEmpty else {
      return reject("E_SDK_CONFIG_INVALID", "The SDK configuration on the iOS side is invalid", nil)
    }

    // Create the push configuration
    let pushConfig = PushConfigBuilder(appId: config.appId!)
      .setAccessToken(config.accessToken!)
      .setMarketingCloudServerUrl(config.cloudServerURL!)
      .setMid(config.mid!)
      .setAnalyticsEnabled(config.analyticsEnabled)
      .setApplicationControlsBadging(config.applicationControlsBadging)
      .setLocationEnabled(config.locationEnabled)
      .setInboxEnabled(config.inboxEnabled)
      .build()

    // Create the SDK configuration
    let sdkConfig = ConfigBuilder().setPush(config: pushConfig) { [weak self] result in
      guard result == .success else {
        return resolve(false)
      }

      // Tell the SDK how to handle incoming urls
      SFMCSdk.mp.setURLHandlingDelegate(RNMarketingCloudDelegate.shared)

      // Ask Apple to initialize push notifications so that we get a device token
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications();
        resolve(true)
      }
    }.build()

    SFMCSdk.initializeSdk(sdkConfig)
  }

  /// Enables or disables verbose logging within the native Marketing Cloud SDK.
  @objc public func setDebugLoggingEnabled(_ enabled: Bool) {
    SFMCSdk.mp.setDebugLoggingEnabled(enabled)
  }
}

// MARK: - Push Messaging

extension RNMarketingCloud {
  /// Returns the token used to send push messages to the device.
  @objc public func getDeviceToken(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.deviceToken()
    resolve(result)
  }

  /// Returns the profile id currently set on the device.
  @objc public func getProfileId(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.contactKey()
    resolve(result)
  }

  /// Sets the profile id for the device's user.
  @objc public func setProfileId(_ profileId: String) {
    SFMCSdk.identity.setProfileId(profileId)
  }

  /// Sets custom profile attributes on the push notification record.
  @objc public func setProfileAttributes(_ attributes: [String:String]) {
    SFMCSdk.identity.setProfileAttributes(attributes)
  }

  /// Indicates if the push messaging functionality is enabled.
  @objc public func isPushEnabled(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.pushEnabled()
    resolve(result)
  }

  /// Enables or disables the push messaging functionality.
  @objc public func setPushEnabled(_ enabled: Bool) {
    SFMCSdk.mp.setPushEnabled(enabled)
  }
}

// MARK: - Push Messaging Inbox

extension RNMarketingCloud {
  /// Returns all messages in the inbox.
  @objc public func getAllMessages(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let messages = SFMCSdk.mp.getAllMessages()
    let result = convertMessages(messages)
    resolve(result)
  }

  /// Returns the total number of messages in the inbox.
  @objc public func getAllMessagesCount(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.getAllMessagesCount()
    resolve(result)
  }

  /// Returns the number of unread messages in the inbox.
  @objc public func getUnreadMessagesCount(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.getUnreadMessagesCount()
    resolve(result)
  }

  /// Marks a single message as deleted.
  @objc public func markMessageDeleted(_ messageId: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.markMessageWithIdDeleted(messageId: messageId)
    resolve(result)
  }

  /// Marks a single message as read.
  @objc public func markMessageRead(_ messageId: String, resolver resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.markMessageWithIdRead(messageId: messageId)
    resolve(result)
  }

  /// Marks all messages in the inbox as deleted.
  @objc public func markAllMessagesDeleted(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.markAllMessagesDeleted()
    resolve(result)
  }

  /// Marks all messages in the inbox as read.
  @objc public func markAllMessagesRead(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.markAllMessagesRead()
    resolve(result)
  }

  /// Reload and refresh Inbox messages from the MarketingCloud server.
  /// The underlying request to the server will be throttled such that it will execute at most every 60 seconds.
  @objc public func refreshMessages(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    let result = SFMCSdk.mp.refreshMessages()
    resolve(result)
  }
}

// MARK: - Native

public extension RNMarketingCloud {
  /// Responsible for sending the Apple device token back to Salesforce. It marks the end of the token registration flow.
  /// If it is unable to reach Salesforce server, it will save the token and try again later.
  @objc public static func setDeviceToken(_ token: Data) {
    SFMCSdk.mp.setDeviceToken(token)
  }

  /// Provides the push notification to the SDK for processing.
  @objc public static func setNotificationRequest(_ request: UNNotificationRequest) {
    SFMCSdk.mp.setNotificationRequest(request)
  }

  /// Provides user info on the push notification to the SDK for processing.
  @objc public static func setNotificationUserInfo(_ userInfo: [AnyHashable : Any]) {
    SFMCSdk.mp.setNotificationUserInfo(userInfo)
  }
}

// MARK: - Delegate

public class RNMarketingCloudDelegate: NSObject, SFMCSDK.URLHandlingDelegate {
  public static var shared = RNMarketingCloudDelegate()

  /// Raised by the SDK when it needs to know how to handle incoming urls.
  public func sfmc_handleURL(_ url: URL, type: String) {
    RCTLinkingManager.application(.shared, open: url, options: [:])
  }
}

// MARK: - Helpers

private extension RNMarketingCloud {
  /// Converts a list of InboxMessage to a WritableArray so that it can be
  /// passed to the JavaScript implementation.
  private func convertMessages(_ objects: [Any]?) -> [[String: Any]] {
    return objects?.compactMap(convertMessage) ?? []
  }

  /// Converts a single InboxMessage to a WritableMap that can be passed
  /// to the JavaScript implementation.
  private func convertMessage(_ object: Any) -> [String: Any]? {
    guard let message = object as? [String: Any] else {
      return nil
    }

    var result = [String: Any]()
    result["id"] = message["id"]
    result["subject"] = message["subject"]
    result["url"] = message["url"]
    result["read"] = convertToBoolean(message["read"])
    result["deleted"] = convertToBoolean(message["deleted"])
    result["sendDateEpoch"] = convertToEpoch(message["sendDateUtc"])
    result["startDateEpoch"] = convertToEpoch(message["startDateUtc"])
    result["endDateEpoch"] = convertToEpoch(message["endDateUtc"])
    return result
  }

  /// Converts the value to a boolean.
  private func convertToBoolean(_ value: Any) -> Bool {
    if let bool = value as? Bool { return bool }
    if let number = value as? Int { return number == 1 }
    return false
  }

  /// Converts the value to a Date and then returns the number of milliseconds
  /// since 00:00:00 UTC on 1 January 1970.
  private func convertToEpoch(_ value: Any) -> Any? {
    guard let date = value as? Date else { return NSNull() }
    return date.timeIntervalSince1970 * 1000
  }
}
