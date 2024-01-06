import 'package:flutter/cupertino.dart';
import 'package:school_web/web/base/stream/base_stream_controller.dart';

class BaseController<T extends State<StatefulWidget>> {
  late final List<BaseStreamController> streamCtrls = [];

  late final List<TextEditingController> textCtrls = [];

  late final List<ValueNotifier> notifiers = [];

  final T state;
  final BuildContext context;

  BaseController(this.state) : context = state.context {
    onInit();
  }

  void onInit() {}

  void onDispose() {
    for (final controller in streamCtrls) {
      controller.dispose();
    }
    for (final controller in textCtrls) {
      controller.dispose();
    }
    for (final controller in notifiers) {
      controller.dispose();
    }
  }
}
