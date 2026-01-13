import 'package:flutter/services.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

class AuthHandler {
  Future<dynamic> handle(MethodCall call) async {
    if (call.method != 'initializeTFS') return null;

    final data = Map<String, dynamic>.from(call.arguments);

    if (data.containsKey('baseUrl') && !TFS().isInitialized) {
      TFS().initialize(baseUrl: data['baseUrl']);
    }

    if (data.keys.toSet().containsAll({
      'authToken',
      'portalToken',
      'appId',
      'clientId',
      'publicKey',
    })) {
      TFS().registerApp(
        authorization: data['authToken'],
        portalToken: data['portalToken'],
        appId: data['appId'],
        clientId: data['clientId'],
        publicKey: data['publicKey'],
      );
    }

    return true;
  }
}
