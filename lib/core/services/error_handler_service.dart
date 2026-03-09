import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final errorHandlerProvider = Provider((ref) => ErrorHandlerService());

/// Centralized error handling service
class ErrorHandlerService {
  /// Show user-friendly error message
  void showError(BuildContext context, dynamic error, {String? title}) {
    final message = _getUserFriendlyMessage(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success message
  void showSuccess(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show warning message
  void showWarning(BuildContext context, String message, {String? title}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  Text(message),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Convert technical errors to user-friendly messages
  String _getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Network errors
    if (errorString.contains('socket') || 
        errorString.contains('network') ||
        errorString.contains('connection')) {
      return 'Unable to connect. Please check your internet connection.';
    }
    
    // Timeout errors
    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    // Authentication errors
    if (errorString.contains('auth') || 
        errorString.contains('unauthorized') ||
        errorString.contains('invalid-credential')) {
      return 'Authentication failed. Please check your credentials.';
    }
    
    // Permission errors
    if (errorString.contains('permission')) {
      return 'Permission denied. Please grant the required permissions.';
    }
    
    // API errors
    if (errorString.contains('400')) {
      return 'Invalid request. Please check your input.';
    }
    if (errorString.contains('401')) {
      return 'Session expired. Please sign in again.';
    }
    if (errorString.contains('403')) {
      return 'Access denied. You don\'t have permission for this action.';
    }
    if (errorString.contains('404')) {
      return 'Resource not found.';
    }
    if (errorString.contains('500') || errorString.contains('502') || errorString.contains('503')) {
      return 'Server error. Please try again later.';
    }
    
    // Nova/AI errors
    if (errorString.contains('nova') || errorString.contains('api key')) {
      return 'AI service unavailable. Please try again later.';
    }
    
    // Storage errors
    if (errorString.contains('storage') || errorString.contains('disk')) {
      return 'Storage error. Please free up some space.';
    }
    
    // Default fallback
    return 'Something went wrong. Please try again.';
  }

  /// Execute async operation with error handling and retry
  Future<T?> executeWithRetry<T>({
    required Future<T> Function() operation,
    required BuildContext context,
    int maxRetries = 2,
    String? errorTitle,
    bool showSuccessMessage = false,
    String? successMessage,
  }) async {
    int attempts = 0;
    
    while (attempts <= maxRetries) {
      try {
        final result = await operation();
        
        if (showSuccessMessage && successMessage != null) {
          showSuccess(context, successMessage);
        }
        
        return result;
      } catch (e) {
        attempts++;
        
        if (attempts > maxRetries) {
          showError(context, e, title: errorTitle);
          return null;
        }
        
        // Wait before retry (exponential backoff)
        await Future.delayed(Duration(seconds: attempts));
      }
    }
    
    return null;
  }
}
