import 'package:flutter/material.dart';

class MyAlertBox {
  final Function? onCancle;
  final Function? deleteForMe;
  final Function? deleteForAll;

  MyAlertBox({this.onCancle, this.deleteForMe, this.deleteForAll});
  AlertDialog deleteMSgAlert(BuildContext context, bool forBoth) {
    return AlertDialog(
      title: const Text('Delete Messages'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                if (onCancle != null) {
                  onCancle!();
                }
                Navigator.of(context).pop();
              },
              child: const Text("Cancle")),
          TextButton(
              onPressed: () {
                if (deleteForMe != null) {
                  deleteForMe!();
                }
                Navigator.of(context).pop();
              },
              child: const Text("Delete for Me")),
          if (forBoth)
            TextButton(
                onPressed: () {
                  if (deleteForAll != null) {
                    deleteForAll!();
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Delete for All")),
        ],
      ),
    );
  }
}
