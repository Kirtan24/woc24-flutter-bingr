import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorHandler {
  static String handleAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'The email address is not valid. Please enter a valid email.';
      case 'user-not-found':
        return 'No account found with this email. Please sign up first.';
      case 'wrong-password':
        return 'The password you entered is incorrect. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please log in instead.';
      case 'weak-password':
        return 'Your password is too weak. Please choose a stronger one.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'network-request-failed':
        return 'A network error occurred. Check your connection and try again.';
      default:
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  static String handleGenericException(Exception exception) {
    return 'An error occurred: ${exception.toString()}. Please try again later.';
  }

  static String handleUnknownError() {
    return 'Something went wrong. Please try again later.';
  }
}
