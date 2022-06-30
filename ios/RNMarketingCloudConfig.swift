import Foundation

@objc public class RNMarketingCloudConfig: NSObject {
  @objc public var appId: String?
  @objc public var accessToken: String?
  @objc public var cloudServerURL: URL?
  @objc public var mid: String?

  @objc public var analyticsEnabled = false
  @objc public var applicationControlsBadging = false
  @objc public var locationEnabled = false
  @objc public var inboxEnabled = false
}
