import 'package:flutter/material.dart';
import '../../scripts/utils/vibration_helper.dart';

/// InputKeyboard Widget
///
/// A custom keyboard widget for input with 0-9 numbers and A-Z letters
class InputKeyboard extends StatefulWidget {
  final Function(String) onTextChanged;
  final Set<String> availableCharacters;

  const InputKeyboard({
    super.key,
    required this.onTextChanged,
    this.availableCharacters = const <String>{},
  });

  @override
  State<InputKeyboard> createState() => _InputKeyboardState();
}

class _InputKeyboardState extends State<InputKeyboard> {
  String _currentText = '';
  bool _isProcessing = false; // Prevent double input

  void _onKeyPressed(String key) {
    if (_isProcessing) return; // Prevent double input

    // Check if adding this key would exceed 4 character limit
    if (_currentText.length >= 4) return;

    // Add vibration feedback
    _vibrate();

    _isProcessing = true; // set without rebuild
    setState(() {
      _currentText += key;
    });

    widget.onTextChanged(_currentText);

    // Reset processing flag after a short delay (no rebuild needed)
    Future.delayed(const Duration(milliseconds: 100), () {
      _isProcessing = false;
    });
  }

  void _onBackspace() {
    if (_isProcessing || _currentText.isEmpty) return; // Prevent double input

    // Add vibration feedback
    _vibrate();

    _isProcessing = true; // set without rebuild
    setState(() {
      _currentText = _currentText.substring(0, _currentText.length - 1);
    });

    widget.onTextChanged(_currentText);

    // Reset processing flag after a short delay (no rebuild needed)
    Future.delayed(const Duration(milliseconds: 100), () {
      _isProcessing = false;
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
    VibrationHelper.lightVibrate();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.only(
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
            // Keyboard content
            Container(
              height: 280, // Limit keyboard height
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
    // Filter letters to only show available ones, but keep them in original order
    final allLetters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];

    // Filter to only available letters, maintaining original order
    final availableLetters = allLetters
        .where((letter) => widget.availableCharacters.contains(letter))
        .toList();

    return SingleChildScrollView(
      child: Column(
        children: availableLetters
            .map(
              (letter) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                child: _buildKey(letter), // Use the regular _buildKey method
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildKey(String text) {
    final scheme = Theme.of(context).colorScheme;
    final isLengthLimit = _currentText.length >= 4;
    final isAvailable = widget.availableCharacters.isNotEmpty &&
        widget.availableCharacters.contains(text);
    final isNumber = RegExp(r'[0-9]').hasMatch(text);
    final isDisabled = isLengthLimit || !isAvailable;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: isDisabled ? null : () => _onKeyPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _getKeyBackgroundColor(isDisabled, isAvailable, isNumber),
          elevation: isDisabled ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ).copyWith(
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          animationDuration: const Duration(milliseconds: 0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDisabled
                ? scheme.onSurface.withOpacity(0.38)
                : scheme.onSurface,
          ),
        ),
      ),
    );
  }

  Color? _getKeyBackgroundColor(
      bool isDisabled, bool isAvailable, bool isNumber) {
    final scheme = Theme.of(context).colorScheme;
    if (isDisabled) {
      return scheme.surfaceVariant.withOpacity(0.5);
    } else {
      return scheme.surfaceVariant;
    }
  }

  Widget _buildClearKey() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: _onClearAll,
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.tertiaryContainer,
          foregroundColor: scheme.onTertiaryContainer,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          '-',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: scheme.onTertiaryContainer),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: _onBackspace,
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.errorContainer,
          foregroundColor: scheme.onErrorContainer,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Icon(Icons.backspace, size: 20, color: scheme.onErrorContainer),
      ),
    );
  }
}
