import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const authChannel = MethodChannel('embedded_flutter/auth');
  authChannel.setMethodCallHandler((call) async {
    if (call.method == 'initializeTFS') {
      final baseUrl = call.arguments['baseUrl'];
      final authToken = call.arguments['authToken'];
      final portalToken = call.arguments['portalToken'];
      final appId = call.arguments['appId'];
      final clientId = call.arguments['clientId'];
      final publicKey = call.arguments['publicKey'];

      TFS().initialize(
        baseUrl: baseUrl,
        theme: AppTheme.lightTheme(),
        onEvent: (String eventName, Map<String, dynamic>? data) {},
        onTokenExpiration: () async {
          TFS().registerApp(
            authorization: authToken,
            portalToken: portalToken,
            appId: appId,
            clientId: clientId,
            publicKey: publicKey,
          );
        },
      );
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel _channel = MethodChannel('embedded_flutter');

  String displayMode = 'direct';
  String text = 'Waiting for iOS';
  double width = 300;
  double height = 200;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'setData') {
        final data = Map<String, dynamic>.from(call.arguments);
        setState(() {
          text = data['text'] ?? text;
          width = (data['width'] ?? width).toDouble();
          height = (data['height'] ?? height).toDouble();
          displayMode = data['mode'] ?? displayMode;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            displayMode == 'fullscreen' ? Colors.white : Colors.transparent,
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (displayMode) {
      case 'direct':
        return _buildDirectView();
      case 'card':
        return _buildCardView();
      case 'fullscreen':
        return LearnDashboard();
      default:
        return _buildDirectView();
    }
  }

  Widget _buildDirectView() {
    return Center(
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildCardView() {
    return GestureDetector(
      onTap: () {
        _channel.invokeMethod('closeCard');
      },
      child: Center(
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.flip, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(text, style: const TextStyle(fontSize: 18)),
              Text(
                'Tap to go back',
                style: TextStyle(fontSize: 14, color: Colors.green.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
