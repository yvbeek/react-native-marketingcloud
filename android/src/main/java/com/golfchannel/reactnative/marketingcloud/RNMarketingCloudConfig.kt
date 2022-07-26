package com.golfchannel.reactnative.marketingcloud

import android.content.Intent
import androidx.annotation.DrawableRes
import com.salesforce.marketingcloud.notifications.NotificationMessage

class RNMarketingCloudConfig {
  lateinit var appId: String
  lateinit var accessToken: String
  lateinit var cloudServerURL: String
  lateinit var senderId: String

  @JvmField @DrawableRes
  var notificationIcon: Int = 0
  lateinit var notificationUrlHandler: (url: String?) -> Intent

  @JvmField
  var analyticsEnabled = false

  @JvmField
  var inboxEnabled = false
}
