import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorHandler {
  static String handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email. Please check your email or sign up.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'email-already-in-use':
        return 'This email is already registered. Try logging in or resetting your password.';
      case 'weak-password':
        return 'The password is too weak. Try a stronger password.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-email': // For Forgot Password
        return 'Invalid email format. Please enter a valid email.';
      case 'user-disabled': // For Forgot Password
        return 'This account has been disabled. Contact support for assistance.';
      case 'missing-email': // For Forgot Password
        return 'Email address is required. Please enter your email.';
      case 'quota-exceeded': // Firebase limits exceeded
        return 'Service temporarily unavailable. Please try again later.';
      default:
        return 'An error occurred: ${e.message ?? "Unknown error"}. Please try again.';
    }
  }

  static String handleGenericException(Exception e) {
    return 'Unexpected error: ${e.toString()}';
  }
}
