import 'package:flutter_riverpod/flutter_riverpod.dart';

final validationServiceProvider = Provider((ref) => ValidationService());

/// Centralized validation service
class ValidationService {
  /// Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validate password strength
  String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Validate password confirmation
  String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Validate phone number
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    // Check if it's a valid length (10-15 digits)
    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }

  /// Validate required field
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate max length
  String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }
    return null;
  }

  /// Validate min length
  String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value != null && value.isNotEmpty && value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    return null;
  }

  /// Validate numeric value
  String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
    }
    
    return null;
  }

  /// Validate positive number
  String? validatePositiveNumber(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) return numericError;
    
    if (value != null && value.isNotEmpty) {
      final number = double.parse(value);
      if (number <= 0) {
        return '$fieldName must be greater than zero';
      }
    }
    
    return null;
  }

  /// Validate URL
  String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }

  /// Validate tax ID (simple format check)
  String? validateTaxId(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    // Remove all non-alphanumeric characters
    final cleaned = value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    
    // Check if it's a reasonable length (varies by country)
    if (cleaned.length < 5 || cleaned.length > 20) {
      return 'Please enter a valid tax ID';
    }
    
    return null;
  }

  /// Validate amount (currency)
  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    
    // Remove currency symbols and commas
    final cleaned = value.replaceAll(RegExp(r'[\$,]'), '');
    
    final amount = double.tryParse(cleaned);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    
    if (amount < 0) {
      return 'Amount cannot be negative';
    }
    
    if (amount > 1000000) {
      return 'Amount seems too large. Please verify.';
    }
    
    return null;
  }

  /// Get password strength (0-4)
  int getPasswordStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) {
      strength++;
    }
    if (password.length >= 12) {
      strength++;
    }
    if (password.contains(RegExp(r'[A-Z]')) && 
        password.contains(RegExp(r'[a-z]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      strength++;
    }
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength++;
    }
    
    return strength > 4 ? 4 : strength;
  }

  /// Get password strength label
  String getPasswordStrengthLabel(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Weak';
    }
  }
}
