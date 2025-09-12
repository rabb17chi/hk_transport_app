import 'package:flutter/material.dart';
import '../scripts/kmb_api_service.dart';

/// ETA Display Component
///
/// A reusable widget for displaying real-time bus ETA information
class ETADisplay extends StatelessWidget {
  final List<KMBETA> etas;
  final bool isLoading;
  final String selectedRoute;
  final String? errorMessage;

  const ETADisplay({
    super.key,
    required this.etas,
    required this.isLoading,
    required this.selectedRoute,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading ETA data...'),
              ],
            ),
          ),
        ),
      );
    }

    if (errorMessage != null && errorMessage!.isNotEmpty) {
      return Card(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[800]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red[800]),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (etas.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.info_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 8),
              const Text(
                'No ETA data available',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'This might be due to:\n• No buses currently running\n• Service not available at this time\n• Invalid route/stop combination',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Real-time ETA Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${etas.length} bus${etas.length > 1 ? 'es' : ''}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...etas.map((eta) => _buildETAItem(eta)),
          ],
        ),
      ),
    );
  }

  Widget _buildETAItem(KMBETA eta) {
    final minutes = eta.minutesUntilArrival;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(minutes),
          child: Icon(
            _getStatusIcon(minutes),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          'Route ${eta.route}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(eta.destEn),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _getTimeDisplay(minutes, eta.eta),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getStatusColor(minutes),
                fontSize: 16,
              ),
            ),
            if (eta.rmkEn.isNotEmpty || eta.rmkTc.isNotEmpty)
              Text(
                eta.rmkEn.isNotEmpty ? eta.rmkEn : eta.rmkTc,
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

  Color _getStatusColor(int minutes) {
    if (minutes < 0) return Colors.grey;
    if (minutes == 0) return Colors.green;
    if (minutes <= 5) return Colors.orange;
    return Colors.blue;
  }

  IconData _getStatusIcon(int minutes) {
    if (minutes < 0) return Icons.schedule;
    if (minutes == 0) return Icons.directions_bus;
    if (minutes <= 5) return Icons.warning;
    return Icons.schedule;
  }

  String _getTimeDisplay(int minutes, String eta) {
    if (minutes > 0) {
      return '${minutes} min';
    } else if (minutes == 0) {
      return 'Arriving now';
    } else {
      // Format the ETA time for display
      try {
        final etaTime = DateTime.parse(eta);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final etaToday = DateTime(etaTime.year, etaTime.month, etaTime.day);

        if (etaToday.isAtSameMomentAs(today)) {
          return '${etaTime.hour.toString().padLeft(2, '0')}:${etaTime.minute.toString().padLeft(2, '0')}';
        } else {
          return '${etaTime.month}/${etaTime.day} ${etaTime.hour.toString().padLeft(2, '0')}:${etaTime.minute.toString().padLeft(2, '0')}';
        }
      } catch (e) {
        return eta;
      }
    }
  }
}
