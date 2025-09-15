import 'package:flutter/material.dart';

/// InputKeyboard Widget
///
/// A custom keyboard widget for input
class InputKeyboard extends StatefulWidget {
  const InputKeyboard({super.key});

  @override
  State<InputKeyboard> createState() => _InputKeyboardState();
}

class _InputKeyboardState extends State<InputKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('InputKeyboard Widget111'),
    );
  }
}
