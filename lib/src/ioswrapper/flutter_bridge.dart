import 'package:flutter/services.dart';
import 'package:tradeable_flutter_sdk/src/ioswrapper/navigation_handle.dart';
import 'auth_handler.dart';

class FlutterBridge {
  static final FlutterBridge _instance = FlutterBridge._();
  factory FlutterBridge() => _instance;
  FlutterBridge._();

  static const MethodChannel base = MethodChannel('embedded_flutter');
  static const MethodChannel auth = MethodChannel('embedded_flutter/auth');
  static const MethodChannel nav = MethodChannel('embedded_flutter/navigation');

  final AuthHandler authHandler = AuthHandler();
  final NavigationHandler navHandler = NavigationHandler();

  void initialize() {
    auth.setMethodCallHandler(authHandler.handle);
    nav.setMethodCallHandler(navHandler.handle);
    base.setMethodCallHandler(navHandler.handleLegacy);
  }
}
