import 'package:flutter/material.dart';

/// BookmarkedRouteWithStation Widget
///
/// A widget for displaying bookmarked routes with their stations
class BookmarkedRouteWithStation extends StatefulWidget {
  const BookmarkedRouteWithStation({super.key});

  @override
  State<BookmarkedRouteWithStation> createState() =>
      _BookmarkedRouteWithStationState();
}

class _BookmarkedRouteWithStationState
    extends State<BookmarkedRouteWithStation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('BookmarkedRouteWithStation Widget'),
    );
  }
}
