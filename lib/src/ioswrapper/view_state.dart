import 'package:flutter/material.dart';

class ViewState extends ChangeNotifier {
  String mode = 'direct';
  String text = '';
  double width = 300;
  double height = 200;
  int topicId = 0;

  void update(Map<String, dynamic> data) {
    mode = data['mode'] ?? mode;
    text = data['text'] ?? text;
    width = (data['width'] ?? width).toDouble();
    height = (data['height'] ?? height).toDouble();
    topicId = data['topicId'] ?? topicId;
    notifyListeners();
  }
}
