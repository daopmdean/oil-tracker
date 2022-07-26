import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final String title;
  final Function handler;

  const AdaptiveButton({
    Key? key,
    required this.title,
    required this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Platform.isAndroid
        ? TextButton(
            onPressed: () => handler(),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              primary: theme.primaryColor,
            ),
          )
        : CupertinoButton(
            onPressed: () => handler(),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
