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

RNMarketingCloud.configure(config)
```

### Java
```java
Context context = getApplicationContext();

RNMarketingCloudConfig config = new RNMarketingCloudConfig();
config.appId = "<app id>";
config.accessToken = "<access token>";
config.cloudServerURL = "<cloud server url>";
config.senderId = "<sender id>";

config.analyticsEnabled = true;
config.inboxEnabled = true;
config.notificationIcon = R.drawable.ic_notification;
config.notificationUrlHandler = url -> {
    return url == null ?
           new Intent(context, MainActivity.class) :
           new Intent(Intent.ACTION_VIEW, Uri.parse(url));
};

RNMarketingCloud.setup(context, config, result -> {});
```

### JavaScript
```js
import SFMC from "react-native-marketingcloud"

await SFMC.initializeSDK()

let deviceToken = await SFMC.getDeviceToken()

let messages = await SFMC.getAllMessages()
let messageCount = await SFMC.getAllMessagesCount()
```
