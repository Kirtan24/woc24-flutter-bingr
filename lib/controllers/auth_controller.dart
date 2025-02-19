import 'package:bingr/util/helpers/firebase_auth_error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/authentication/mail_sent.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Login Method
  Future<void> login(String email, String password, bool rememberMe) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (rememberMe) {
        await saveLoginDetails(email, password, rememberMe);
      }

      Get.offAllNamed('/home'); // Navigate to home screen on successful login
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseAuthErrorHandler.handleAuthException(e);
      _showErrorToast(errorMessage);
    } catch (e) {
      _showErrorToast(
          FirebaseAuthErrorHandler.handleGenericException(e as Exception));
    }
  }

  // 🔹 Register Method
  Future<void> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.offAllNamed(
          '/home'); // Navigate to home screen after successful registration
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseAuthErrorHandler.handleAuthException(e);
      _showErrorToast(errorMessage);
    } catch (e) {
      _showErrorToast(
          FirebaseAuthErrorHandler.handleGenericException(e as Exception));
    }
  }

  // 🔹 Reset Password Method
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      _showErrorToast("Please enter an email address.");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.offAll(MailSent(email: email));
    } on FirebaseAuthException catch (e) {
      String errorMessage = FirebaseAuthErrorHandler.handleAuthException(e);
      _showErrorToast(errorMessage);
    } catch (e) {
      _showErrorToast(
          FirebaseAuthErrorHandler.handleGenericException(e as Exception));
    }
  }

  // 🔹 Logout Method
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login'); // Navigate to login screen
  }

  // 🔹 Save Login Details
  Future<void> saveLoginDetails(
      String email, String password, bool rememberMe) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', rememberMe);
    }
  }

  // 🔹 Retrieve Login Details
  Future<Map<String, dynamic>> getLoginDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email'),
      'password': prefs.getString('password'),
      'rememberMe': prefs.getBool('rememberMe')
    };
  }

  // 🔹 Clear Login Details
  Future<void> clearLoginDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // 🔹 Show Error Toast
  void _showErrorToast(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}
