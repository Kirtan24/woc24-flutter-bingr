class FormValidators {
  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email.";
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(value)) {
      return "Enter a valid email address.";
    }
    return null;
  }

  // Password Validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password.";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long.";
    }
    return null;
  }

  // Confirm Password Validator (useful for sign-up forms)
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please confirm your password.";
    } else if (value != password) {
      return "Passwords do not match.";
    }
    return null;
  }
}
