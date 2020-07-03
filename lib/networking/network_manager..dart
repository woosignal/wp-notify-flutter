// Copyright (c) 2020, WooSignal Ltd.
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

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wp_notify/enums/wp_route_type.dart';
import 'package:wp_notify/models/responses/WPStoreTokenResponse.dart';
import 'package:wp_notify/models/responses/WPUpdateTokenResponse.dart';
import 'package:wp_notify/wp_notify.dart';

class WPNotifyNetworkManager {
  WPNotifyNetworkManager._privateConstructor();

  static final WPNotifyNetworkManager instance =
  WPNotifyNetworkManager._privateConstructor();

  /// Sends a request to update a users WooCommerce details using
  /// a valid [userToken], set optional parameters for updating user.
  ///
  /// Returns [WCCustomerUpdatedResponse] future.
  /// Throws an [Exception] if fails.
  Future<WPStoreTokenResponse> wpNotifyStoreToken(
      {@required String token,
        @required int userId}) async {

    Map<String, dynamic> payload = {
      "token": token
    };

    if (userId != null) {
      payload["user_id"] = userId;
    }

    // send http request
    final json = await _http(
        method: "POST",
        url: _urlForRouteType(WPNotifyRouteType.WPFcmTokenStore),
        body: payload);

    // return response
    return _jsonHasBadStatus(json)
        ? _throwExceptionForStatusCode(json)
        : WPStoreTokenResponse.fromJson(json);
  }

  /// Sends a request to update a users WooCommerce details using
  /// a valid [userToken], set optional parameters for updating user.
  ///
  /// Returns [WCCustomerUpdatedResponse] future.
  /// Throws an [Exception] if fails.
  Future<WPUpdateTokenResponse> wpNotifyUpdateToken(
      {@required String token,
        @required bool status}) async {

    Map<String, dynamic> payload = {
      "token": token
    };

    if (status != null) {
      payload["status"] = status;
    }

    // send http request
    final json = await _http(
        method: "POST",
        url: _urlForRouteType(WPNotifyRouteType.WPAppFcmTokenUpdate),
        body: payload);

    // return response
    return _jsonHasBadStatus(json)
        ? _throwExceptionForStatusCode(json)
        : WPUpdateTokenResponse.fromJson(json);
  }

  /// Sends a Http request using a valid request [method] and [url] endpoint
  /// from the WP_JSON_API plugin. The [body] and [userToken] is optional but
  /// you can use these if the request requires them.
  ///
  /// Returns a [dynamic] response from the server.
  Future<dynamic> _http(
      {@required String method,
        @required String url,
        dynamic body}) async {
    var response;
    if (method == "GET") {
      response = await http.get(
        url,
        headers: null,
      );
    } else if (method == "POST") {
      Map<String, String> headers = {
        HttpHeaders.contentTypeHeader: "application/json",
      };

      response = await http.post(
        url,
        body: jsonEncode(body),
        headers: headers,
      );
    }

    _devLogger(
        url: response.request.url.toString(),
        payload: method == "GET"
            ? response.request.url.queryParametersAll.toString()
            : body.toString(),
        result: response.body.toString());

    return jsonDecode(response.body);
  }

  /// Logs the output of a app request.
  /// [url] should be set containing the url route for the request.
  /// The [payload] and [result] are optional but are used in the
  /// log output if set. This will only log if shouldDebug is enabled.
  ///
  /// Returns void.
  _devLogger({@required String url, String payload, String result}) {
    String strOutput = "\nREQUEST: " + url;
    if (payload != null) strOutput += "\nPayload: " + payload;
    if (result != null) strOutput += "\nRESULT: " + result;

    // logs response if shouldDebug is enabled
    if (WPNotifyAPI.instance.shouldDebug()) log(strOutput);
  }

  /// Checks if a response payload has a bad status (=> 500).
  ///
  /// Returns [bool] true if status is => 500.
  _jsonHasBadStatus(json) {
    return (json["status"] == null || json["status"] >= 500);
  }

  /// Creates an endpoint with the baseUrl and path.
  ///
  /// Returns [String] of the url route.
  String _urlForRouteType(WPNotifyRouteType wpRouteType) {
    return WPNotifyAPI.instance.getBaseApi() + _getRouteUrlForType(wpRouteType);
  }


  /// The routes available for the WP_JSON_API plugin
  /// set [wpRouteType] and use optional [apiVersion] to change API version.
  ///
  /// Returns [String] url path for request.
  String _getRouteUrlForType(
      WPNotifyRouteType wpRouteType, {
        String apiVersion = 'v1',
      }) {
    String prefix = "wpnotify";
    switch (wpRouteType) {
      case WPNotifyRouteType.WPFcmTokenStore:
        {
          return "/$prefix/$apiVersion/token/store";
        }
      case WPNotifyRouteType.WPAppFcmTokenUpdate:
        {
          return "/$prefix/$apiVersion/token/update";
        }
      default:
        {
          return "";
        }
    }
  }

  /// Throws an exception from the [json] status returned from a payload.
  _throwExceptionForStatusCode(json) {
    if (json != null && json['status'] != null) {
      int statusCode = json["status"];
      String message = json["message"] ?? 'Something went wrong';

      switch (statusCode) {
        case 500:
          throw new Exception(message);
        case 567:
          throw new Exception(message);
        default: {
          throw new Exception('Something went wrong, please check server response');
        }
      }
    }
  }
}