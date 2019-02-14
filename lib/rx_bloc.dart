import 'dart:async';
import 'package:rxdart/rxdart.dart';

abstract class RxBLoC<T, V> {
  final _actions = PublishSubject<T>();
  final _state;

  RxBLoC() : _state = BehaviorSubject<V>() {
    _init();
  }

  RxBLoC.fromInitialState(V initialState)
      : _state = BehaviorSubject<V>(seedValue: initialState) {
    _init();
  }

  void _init() {
    _actions.listen(onAction);
  }

  StreamSink<T> get actionSink => _actions.sink;
  Observable<T> get actionStream => _actions;
  Observable<V> get stateStream => _state.stream;
  V get currentState => _state.value;

  void bind(Observable<RxAction> upstream, StreamSink<dynamic> downstream) {
    upstream.where((a) => a is T).listen((action) => dispatch(action as T));
    _state.listen((data) => downstream.add(data));
  }

  void onAction(T action);

  void dispatch(T action) {
    _actions.add(action);
  }

  void setState(V state) {
    _state.value = state;
  }

  Future dispose() async {
    _actions.close();
    _state.close();
  }
}

abstract class RxAction<Enum, V> {
  final Enum _type;
  final V _payload;

  RxAction(this._type, this._payload);

  Enum get type => _type;
  V get payload => _payload;

  String toString() {
    return _type.toString();
  }
}
