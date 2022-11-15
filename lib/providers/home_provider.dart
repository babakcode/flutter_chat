import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeProvider extends ChangeNotifier{

  TextEditingController conversationTokenTextController = TextEditingController();

  bool _extendedFloatingActionButton = true;
  bool get extendedFloatingActionButton => _extendedFloatingActionButton;

  bool toggleExtendedFloatingActionButton(UserScrollNotification notification) {
    final ScrollDirection direction = notification.direction;
    bool? extended;
    if (direction == ScrollDirection.reverse) {
      extended = false;
    } else if (direction == ScrollDirection.forward) {
      extended = true;
    }
    if(extended != null){
      if(extended != extendedFloatingActionButton){
        _extendedFloatingActionButton = extended;
        notifyListeners();
      }
    }
    return true;
  }
}