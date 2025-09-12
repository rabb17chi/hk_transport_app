import 'package:flutter/material.dart';

/// Search Bar Component
///
/// A reusable widget for search input with button
class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String buttonText;
  final VoidCallback onSearch;
  final bool isLoading;

  const SearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.buttonText,
    required this.onSearch,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.search),
            ),
            onSubmitted: (_) => onSearch(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: isLoading ? null : onSearch,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(buttonText),
        ),
      ],
    );
  }
}
