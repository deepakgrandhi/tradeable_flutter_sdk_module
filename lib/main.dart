import 'package:flutter/material.dart';
import 'package:tradeable_flutter_sdk/src/ioswrapper/flutter_bridge.dart';
import 'package:tradeable_flutter_sdk/src/ioswrapper/view_state.dart';
import 'package:tradeable_flutter_sdk/tradeable_flutter_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBridge().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = FlutterBridge().navHandler.state;

    return AnimatedBuilder(
      animation: state,
      builder: (_, __) {
        return MaterialApp(
          home: Scaffold(
            backgroundColor:
                state.mode == 'fullscreen' ? Colors.white : Colors.transparent,
            body: _build(state),
          ),
        );
      },
    );
  }

  Widget _build(ViewState state) {
    switch (state.mode) {
      case 'direct':
        return _direct(state);
      case 'card':
        return _card(state);
      case 'fullscreen':
        if (!TFS().isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        return TopicDetailPage(topicId: state.topicId);
      default:
        return _direct(state);
    }
  }

  Widget _direct(ViewState s) {
    return Center(
      child: Container(
        width: s.width,
        height: s.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(s.text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _card(ViewState s) {
    return GestureDetector(
      onTap: () {
        FlutterBridge.base.invokeMethod('closeCard');
      },
      child: Center(
        child: Container(
          width: s.width,
          height: s.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(s.text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
