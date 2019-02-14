import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'rx_bloc.dart';

abstract class RxStateProvider extends InheritedWidget {
  final _actions = PublishSubject<RxAction>();
  final _state = PublishSubject<dynamic>();

  RxStateProvider({Key key, Widget child}) : super(key: key, child: child) {
    init();
    initLogging();
  }

  void init();

  void bindBLoC(RxBLoC bloc) {
    debugPrint("RxStateProvider [binding]: " + bloc.runtimeType.toString());
    bloc.bind(_actions, _state);
  }

  void dispatch(RxAction action) {
    _actions.add(action);
  }

  void initLogging() {
    _actions.listen(
        (action) => debugPrint("RxStateProvider [action]: " + action.type.toString()));
    _state.listen((state) => debugPrint("RxStateProvider [state]: " +
        state.runtimeType.toString() +
        ": " +
        state.toString()));
  }

  @override
  bool updateShouldNotify(RxStateProvider oldWidget) => false;

  Future dispose() async {
    _actions.close();
    _state.close();
  }

  static RxStateProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(RxStateProvider)
        as RxStateProvider);
  }
}
