import 'package:flutter/material.dart';

void showNoSystemWidget(BuildContext context,
    {required String title, required String cancel, required String confirm, required VoidCallback ontap}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black)),
        actions: [
          TextButton(
            child: Text(cancel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: ontap,
            child: Text(
              confirm,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
