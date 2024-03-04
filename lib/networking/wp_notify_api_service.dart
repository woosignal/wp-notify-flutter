// Copyright (c) 2024, WooSignal Ltd.
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

import 'package:nylo_support/networking/ny_api_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wp_notify/wp_notify.dart';

/// The [WpNotifyApiService] is used for making requests to the WP_JSON_API plugin.
class WpNotifyApiService extends NyApiService {
  WpNotifyApiService() : super(null);

  /// The API version to use for the requests.
  String _apiVersion = 'v2';

  /// The prefix to use for the requests.
  String _prefix = "wpnotify";

  @override
  String baseUrl = WPNotifyAPI.instance.getBaseApi();

  @override
  final interceptors = {
    if (WPNotifyAPI.debugMode() == true) PrettyDioLogger: PrettyDioLogger(),
  };

  /// Sends a request to store a user's FCM token into WordPress
  /// using a valid [userToken], set optional parameters for updating user.
  Future<WPStoreTokenResponse> wpNotifyStoreToken(
      {required String token, int? userId}) async {
    Map<String, dynamic> payload = {"token": token};

    if (userId != null) {
      payload["user_id"] = userId;
    }

    // send http request
    return await network(
      request: (api) =>
          api.post("/$_prefix/$_apiVersion/token/store", data: payload),
      handleSuccess: (response) {
        dynamic json = response.data;
        return _jsonHasBadStatus(json)
            ? _throwExceptionForStatusCode(json)
            : WPStoreTokenResponse.fromJson(json);
      },
    );
  }

  /// Sends a request to update a user's FCM token into WordPress
  /// using a valid [token] and [status].
  Future<WPUpdateTokenResponse> wpNotifyUpdateToken(
      {required String token, required bool status}) async {
    Map<String, dynamic> payload = {"token": token};
    payload["status"] = status;

    // send http request
    return await network(
      request: (api) =>
          api.post("/$_prefix/$_apiVersion/token/update", data: payload),
      handleSuccess: (response) {
        dynamic json = response.data;
        return _jsonHasBadStatus(json)
            ? _throwExceptionForStatusCode(json)
            : WPUpdateTokenResponse.fromJson(json);
      },
    );
  }

  /// Checks if a response payload has a bad status (=> 500).
  ///
  /// Returns [bool] true if status is => 500.
  _jsonHasBadStatus(json) {
    return (json["status"] == null || json["status"] >= 500);
  }

  /// Throws an exception from the [json] status returned from a payload.
  _throwExceptionForStatusCode(json) {
    if (json != null && json['status'] != null) {
      int? statusCode = json["status"];
      String message = json["message"] ?? 'Something went wrong';

      switch (statusCode) {
        case 500:
          throw new Exception(message);
        case 567:
          throw new Exception(message);
        default:
          {
            throw new Exception(
                'Something went wrong, please check server response');
          }
      }
    }
  }
}
