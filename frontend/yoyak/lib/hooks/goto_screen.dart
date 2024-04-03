import 'package:flutter/material.dart';

void goToScreen(context, Widget destination) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => destination,
    ),
  );
}
