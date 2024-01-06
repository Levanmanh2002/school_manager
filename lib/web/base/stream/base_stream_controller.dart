import 'dart:async';

class BaseStreamController<T> {
  late StreamController<T> controller;
  late T _value;

  final void Function()? onListen;
  final void Function()? onCancel;
  final bool sync;

  T get value => _value;
  Stream<T> get stream => controller.stream;

  BaseStreamController(T initialValue, {this.onListen, this.onCancel, this.sync = false}) {
    controller = StreamController<T>.broadcast(onListen: onListen, onCancel: onCancel, sync: sync);

    _value = initialValue;
  }

  set value(T newVal) {
    _value = newVal;
    controller.sink.add(newVal);
  }

  dispose() {
    controller.close();
  }
}
