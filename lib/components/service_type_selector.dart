import 'package:flutter/material.dart';

/// Service Type Selector Component
///
/// A reusable widget for selecting KMB bus service types
class ServiceTypeSelector extends StatelessWidget {
  final String selectedServiceType;
  final Function(String) onServiceTypeChanged;

  const ServiceTypeSelector({
    super.key,
    required this.selectedServiceType,
    required this.onServiceTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedServiceType,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: '1',
                  child: Row(
                    children: [
                      Icon(Icons.directions_bus, size: 20),
                      SizedBox(width: 8),
                      Text('Regular Service'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: '2',
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 20),
                      SizedBox(width: 8),
                      Text('Special Service'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: '3',
                  child: Row(
                    children: [
                      Icon(Icons.nightlight_round, size: 20),
                      SizedBox(width: 8),
                      Text('Night Service'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  onServiceTypeChanged(value);
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              _getServiceTypeDescription(selectedServiceType),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getServiceTypeDescription(String serviceType) {
    switch (serviceType) {
      case '1':
        return 'Regular daytime bus service';
      case '2':
        return 'Special routes and express services';
      case '3':
        return 'Night bus service (after midnight)';
      default:
        return '';
    }
  }
}
