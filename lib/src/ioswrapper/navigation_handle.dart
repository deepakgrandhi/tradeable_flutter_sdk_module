import 'package:flutter/services.dart';
import 'view_state.dart';

class NavigationHandler {
  final ViewState state = ViewState();

  Future<dynamic> handle(MethodCall call) async {
    switch (call.method) {
      case 'navigateTo':
        state.update(call.arguments);
        return null;

      case 'replaceRoute':
        state.update(call.arguments);
        return null;

      case 'popToRoot':
        state.update(call.arguments);
        return null;

      case 'receiveData':
        state.update(call.arguments);
        return null;

      case 'goBack':
        return null;

      case 'sendData':
        return null;
    }
    return null;
  }

  Future<dynamic> handleLegacy(MethodCall call) async {
    if (call.method == 'setData') {
      state.update(Map<String, dynamic>.from(call.arguments));
    }
    if (call.method == 'closeCard') {
      SystemNavigator.pop();
    }
    return null;
  }
}
