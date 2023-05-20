import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function() onCancel;
  final Function() onConfirm;

  DeleteConfirmationDialog({
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        FlatButton(
          onPressed: onCancel,
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: onConfirm,
          child: Text('Delete'),
        ),
      ],
    );
  }
}