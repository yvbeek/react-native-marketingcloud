package com.golfchannel.reactnative.marketingcloud

import android.content.Intent
import androidx.annotation.DrawableRes
import com.salesforce.marketingcloud.notifications.NotificationMessage

class RNMarketingCloudConfig {
  lateinit var appId: String
  lateinit var accessToken: String
  lateinit var cloudServerURL: String
  lateinit var senderId: String

  @DrawableRes
  var notificationIcon: Int = 0
  lateinit var notificationUrlHandler: (url: String?) -> Intent

  var analyticsEnabled = false
  var inboxEnabled = false
}
