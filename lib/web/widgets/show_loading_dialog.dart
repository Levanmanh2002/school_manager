import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:school_web/main.dart';

Future<S?> showLoadingDialog<S>(
  BuildContext context,
  Future<void> Function(BuildContext) onHandleWhenLoading, {
  bool needPopDialog = true,
}) {
  var loadingCallbackExecuted = false;

  return showDialog<S>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!loadingCallbackExecuted) {
          loadingCallbackExecuted = true;

          await onHandleWhenLoading(ctx);

          if (needPopDialog && Navigator.canPop(ctx)) {
            Navigator.pop(ctx);
          }
        }
      });
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SpinKitFadingCircle(
                size: 50,
                color: appTheme.textDesColor,
              ),
            ),
          ),
        ],
      );
    },
  );
}
