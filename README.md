# WP Notify for Flutter - Send push notifications from WordPress using Firebase Cloud Messaging

[Official WooSignal package](https://woosignal.com)

## API features:

**Notifications**

* Automatically sends the device token to your WordPress site for a given user/device
* You can assign a token to a WordPress user
* Send notifications from WordPress with our API

To use this Flutter package you must have the [WP Notify Plugin](https://woosignal.com/plugins/wordpress/wp-notify) installed first on your WordPress site, you can download it via the WooSignal website.

### Getting Started #
In your flutter project add the dependency:

``` dart
dependencies:
  ...
  wp_notify: ^2.0.0
```

### Usage example #
Import wp_notify.dart
``` dart
import 'package:wp_notify/wp_notify.dart';
```

### Example using WP Notify

``` dart
import 'package:wp_notify/wp_notify.dart';
...

void main() {

WPNotifyAPI.instance.initWith(baseUrl: "https://mysite.com");

...
```


### Available API Requests

#### WordPress - wpNotifyStoreToken
- Used for storing an FCM token
``` dart
WPStoreTokenResponse wpStoreTokenResponse;
try {
    wpStoreTokenResponse = WPNotifyAPI.instance.api((request) => request.wpNotifyStoreToken(token: token, userId: usersId));
} on Exception catch (e) {
    print(e);
}
```

#### WordPress - Updating a tokens status (e.g. if you want to turn off notifications)
- Used for updating the status of an FCM token
``` dart
WPUpdateTokenResponse wpUpdateTokenResponse;
try {
     wpUpdateTokenResponse = WPNotifyAPI.instance.api((request) => request.wpNotifyUpdateToken(token: token, status: true));
} on Exception catch (e) {
    print(e);
}
```


For help getting started with WooSignal, view our
[online documentation](https://woosignal.com/docs/flutter/wp-notify), which offers a more detailed guide.

## Usage
To use this plugin, add `wp_notify` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins).

## Note
Install WordPress plugin "WP Notify" 2.0.x or later for version 2.0.0

Disclaimer: This plugin is not affiliated with or supported by Automattic, Inc. All logos and trademarks are the property of their respective owners.

