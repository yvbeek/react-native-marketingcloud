# React-Native Marketing Cloud

React-Native library for the Salesforce Marketing Cloud SDK

## Installation

```sh
yarn install react-native-marketingcloud
```

## Usage

### Swift
```swift
var config = RNMarketingCloudConfig()
config.appId = "<app id>"
config.accessToken = "<access token>"
config.cloudServerURL = URL(string: "<cloud server url>")!
config.mid = "<mid>"

config.analyticsEnabled = true
config.applicationControlsBadging = false
config.inboxEnabled = true
config.locationEnabled = false

RNMarketingCloud.config = config
```

### Kotlin
```kotlin
val config = RNMarketingCloudConfig().apply {
    appId = "<app id>"
    accessToken = "<access token>"
    cloudServerURL = "<cloud server url>"
    senderId = "<sender id>"

    analyticsEnabled = true
    inboxEnabled = true

    notificationIcon = R.drawable.ic_notification
    notificationUrlHandler = { url ->
        if (url == null) {
            Intent(getApplicationContext(), MainActivity::class.java)
        } else {
            Intent(Intent.ACTION_VIEW, Uri.parse(url))
        }
    }
}

RNMarketingCloud.config = config
```

### JavaScript
```js
import SFMC from "react-native-marketingcloud"

await SFMC.initializeSDK()

let deviceToken = await SFMC.getDeviceToken()

let messages = await SFMC.getAllMessages()
let messageCount = await SFMC.getAllMessagesCount()
```
