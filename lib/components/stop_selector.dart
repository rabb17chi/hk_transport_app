import 'package:flutter/material.dart';
import '../scripts/kmb_api_service.dart';

/// Stop Selector Component
///
/// A reusable widget for searching and selecting KMB bus stops
class StopSelector extends StatefulWidget {
  final List<KMBStop> stops;
  final String selectedStop;
  final Function(String) onStopSelected;
  final Function(String) onSearch;
  final bool isLoading;

  const StopSelector({
    super.key,
    required this.stops,
    required this.selectedStop,
    required this.onStopSelected,
    required this.onSearch,
    required this.isLoading,
  });

  @override
  State<StopSelector> createState() => _StopSelectorState();
}

class _StopSelectorState extends State<StopSelector> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    if (_searchController.text.isNotEmpty) {
      widget.onSearch(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search Stops',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Enter stop name (e.g., Central, 中環)',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: widget.isLoading ? null : _performSearch,
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Found ${widget.stops.length} stops'),
            if (widget.stops.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Select Stop',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: widget.stops.length,
                  itemBuilder: (context, index) {
                    final stop = widget.stops[index];
                    return ListTile(
                      title: Text(stop.nameEn),
                      subtitle: Text('${stop.nameTc} (${stop.nameSc})'),
                      trailing: widget.selectedStop == stop.stop
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () => widget.onStopSelected(stop.stop),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
