import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider((ref) => AuthService());

/// AWS Cognito Auth Service
/// Captures Cognito sub (User ID) for memory actorId
class AuthService {
  String? _cognitoSub;
  
  /// Get current user's Cognito sub (unique user ID)
  String? get cognitoSub => _cognitoSub;

  /// Check if user is authenticated
  Future<bool> checkAuthStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        // Capture Cognito sub
        await _captureCognitoSub();
        return true;
      }
      return false;
    } catch (e) {
      safePrint('[Auth] Error checking auth status: $e');
      return false;
    }
  }

  /// Get current user's email
  Future<String?> getCurrentUserEmail() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();
      
      final emailAttr = attributes.firstWhere(
        (attr) => attr.userAttributeKey == AuthUserAttributeKey.email,
        orElse: () => throw Exception('Email not found'),
      );
      
      return emailAttr.value;
    } catch (e) {
      safePrint('[Auth] Error getting user email: $e');
      return null;
    }
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        await _captureCognitoSub();
        safePrint('[Auth] ✓ Sign in successful. Cognito sub: $_cognitoSub');
      }
    } catch (e) {
      safePrint('[Auth] Sign in error: $e');
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<void> signUp(String email, String password) async {
    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: {
            AuthUserAttributeKey.email: email,
          },
        ),
      );

      safePrint('[Auth] Sign up result: ${result.nextStep.signUpStep}');
    } catch (e) {
      safePrint('[Auth] Sign up error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      _cognitoSub = null;
      safePrint('[Auth] ✓ Sign out successful');
    } catch (e) {
      safePrint('[Auth] Sign out error: $e');
      rethrow;
    }
  }

  /// Capture Cognito sub from current user
  Future<void> _captureCognitoSub() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      _cognitoSub = user.userId;
      safePrint('[Auth] Cognito sub captured: $_cognitoSub');
    } catch (e) {
      safePrint('[Auth] Error capturing Cognito sub: $e');
    }
  }

  /// Confirm sign up with verification code
  Future<void> confirmSignUp(String email, String code) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: email,
        confirmationCode: code,
      );

      safePrint('[Auth] Confirm sign up result: ${result.nextStep.signUpStep}');
    } catch (e) {
      safePrint('[Auth] Confirm sign up error: $e');
      rethrow;
    }
  }

  /// Resend confirmation code
  Future<void> resendSignUpCode(String email) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: email);
      safePrint('[Auth] ✓ Confirmation code resent');
    } catch (e) {
      safePrint('[Auth] Resend code error: $e');
      rethrow;
    }
  }
}
