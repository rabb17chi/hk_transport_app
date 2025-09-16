import 'package:flutter/material.dart';
import '../../scripts/vibration_helper.dart';

/// InputKeyboard Widget
///
/// A custom keyboard widget for input with 0-9 numbers and A-Z letters
class InputKeyboard extends StatefulWidget {
  final Function(String) onTextChanged;

  const InputKeyboard({
    super.key,
    required this.onTextChanged,
  });

  @override
  State<InputKeyboard> createState() => _InputKeyboardState();
}

class _InputKeyboardState extends State<InputKeyboard> {
  String _currentText = '';
  bool _isProcessing = false; // Prevent double input

  void _onKeyPressed(String key) {
    if (_isProcessing) return; // Prevent double input

    // Add vibration feedback
    _vibrate();

    setState(() {
      _isProcessing = true;
      _currentText += key;
    });

    widget.onTextChanged(_currentText);

    // Reset processing flag after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _onBackspace() {
    if (_isProcessing || _currentText.isEmpty) return; // Prevent double input

    // Add vibration feedback
    _vibrate();

    setState(() {
      _isProcessing = true;
      _currentText = _currentText.substring(0, _currentText.length - 1);
    });

    widget.onTextChanged(_currentText);

    // Reset processing flag after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _onClearAll() {
    if (_isProcessing) return; // Prevent double input

    // Add vibration feedback
    _vibrate();

    setState(() {
      _isProcessing = true;
      _currentText = '';
    });

    widget.onTextChanged(_currentText);

    // Reset processing flag after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _vibrate() {
    // Light vibration feedback using VibrationHelper
    VibrationHelper.lightVibrate();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1),
              // Keyboard content
              Container(
                height: 260, // Limit keyboard height
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: _buildNumberKeyboard(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildLetterKeyboard(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberKeyboard() {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          children: ['1', '2', '3']
              .map((number) => Expanded(child: _buildKey(number)))
              .toList(),
        ),
        const SizedBox(height: 6),
        // Row 2: 4, 5, 6
        Row(
          children: ['4', '5', '6']
              .map((number) => Expanded(child: _buildKey(number)))
              .toList(),
        ),
        const SizedBox(height: 6),
        // Row 3: 7, 8, 9
        Row(
          children: ['7', '8', '9']
              .map((number) => Expanded(child: _buildKey(number)))
              .toList(),
        ),
        const SizedBox(height: 6),
        // Row 4: Clear All (-), 0, backspace
        Row(
          children: [
            Expanded(child: _buildClearKey()),
            const SizedBox(width: 4),
            Expanded(child: _buildKey('0')),
            const SizedBox(width: 4),
            Expanded(child: _buildBackspaceKey()),
          ],
        ),
      ],
    );
  }

  Widget _buildLetterKeyboard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Letters in single column
          'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
          'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
          'U', 'V', 'W', 'X', 'Y', 'Z'
        ]
            .map(
              (letter) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: _buildKey(letter),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildKey(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _onKeyPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildClearKey() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: _onClearAll,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[100],
          foregroundColor: Colors.orange[800],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          '-',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: _onBackspace,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[100],
          foregroundColor: Colors.red[800],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Icon(Icons.backspace, size: 20),
      ),
    );
  }
}
