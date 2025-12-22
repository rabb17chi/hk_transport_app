/// Network Error Helper
///
/// Utility functions to detect and handle network-related errors
class NetworkErrorHelper {
  /// Check if an exception is a network-related error
  static bool isNetworkError(dynamic error) {
    if (error == null) return false;
    
    final errorString = error.toString().toLowerCase();
    
    // Common network error patterns
    final networkErrorPatterns = [
      'socketexception',
      'network',
      'connection',
      'failed host lookup',
      'no address associated with hostname',
      'connection refused',
      'connection timed out',
      'connection reset',
      'network is unreachable',
      'software caused connection abort',
      'connection closed',
      'http',
      'failed to connect',
      'unable to resolve',
      'dns',
      'timeout',
      'offline',
      'no internet',
    ];
    
    return networkErrorPatterns.any((pattern) => errorString.contains(pattern));
  }
  
  /// Extract a clean network error message
  static String getNetworkErrorMessage(dynamic error) {
    if (error == null) return 'Network error occurred';
    
    final errorString = error.toString();
    
    // Check for specific error types
    if (errorString.toLowerCase().contains('socketexception')) {
      return 'Network connection failed';
    }
    if (errorString.toLowerCase().contains('timeout')) {
      return 'Connection timeout';
    }
    if (errorString.toLowerCase().contains('failed host lookup') ||
        errorString.toLowerCase().contains('unable to resolve')) {
      return 'Unable to reach server';
    }
    
    return 'Network error occurred';
  }
}

/// Custom exception for network errors
class NetworkException implements Exception {
  final String message;
  final dynamic originalError;
  
  NetworkException(this.message, [this.originalError]);
  
  @override
  String toString() => message;
}

