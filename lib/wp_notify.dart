// Copyright (c) 2025, WooSignal Ltd.
// All rights reserved.
//
// Redistribution and use in source and binary forms are permitted
// provided that the above copyright notice and this paragraph are
// duplicated in all such forms and that any documentation,
// advertising materials, and other materials related to such
// distribution and use acknowledge that the software was developed
// by the WooSignal. The name of the
// WooSignal may not be used to endorse or promote products derived
// from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

library wp_notify;

import '/networking/wp_notify_api_service.dart';
export '/models/responses/wp_store_token_response.dart';
export '/models/responses/wp_update_token_response.dart';
export '/networking/wp_notify_api_service.dart';

/// MediaPro version
const String _wpNotify = '2.0.4';

/// The [WPNotifyAPI] class is used to configure the WPNotify package.
class WPNotifyAPI {
  WPNotifyAPI._privateConstructor();

  static final WPNotifyAPI instance = WPNotifyAPI._privateConstructor();

  /// Returns the current version of the MediaPro package
  static String get version => _wpNotify;

  /// Base URL for the API
  String? baseUrl;

  /// Debug mode
  bool? shouldDebug;

  /// Path to the WP JSON API
  String? wpJsonPath;

  initWith(
      {required String baseUrl,
      String wpJsonPath = '/wp-json',
      bool shouldDebug = true}) {
    this.baseUrl = baseUrl;
    this.wpJsonPath = wpJsonPath;
    this.shouldDebug = shouldDebug;
  }

  /// Check if debug mode is enabled
  static bool? debugMode() {
    return WPNotifyAPI.instance.shouldDebug;
  }

  /// Returns the base API URL
  String getBaseApi() {
    String url = "";
    if (this.baseUrl != null) {
      url += this.baseUrl!;
    }
    if (this.wpJsonPath != null) {
      url += this.wpJsonPath!;
    }
    return url;
  }

  /// Send an api request from the service
  api(dynamic Function(WpNotifyApiService) request) async {
    return await request(WpNotifyApiService());
  }
}
