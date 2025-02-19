import 'package:bingr/controllers/login_controller.dart';
import 'package:bingr/screens/authentication/forgot_password.dart';
import 'package:bingr/screens/authentication/register.dart';
import 'package:bingr/common/widgets/text_field_widget.dart';
import 'package:bingr/util/helpers/firebase_auth_error_handler.dart';
import 'package:bingr/screens/authentication/validators/form_validators.dart';
import 'package:bingr/util/helpers/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  final LoginController _loginController = LoginController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedDetails();
  }

  Future<void> _loadSavedDetails() async {
    final details = await _loginController.getLoginDetails();
    if (details['rememberMe'] == true) {
      setState(() {
        _emailController.text = details['email'] ?? '';
        _passwordController.text = details['password'] ?? '';
        _isChecked = details['rememberMe'] ?? false;
      });
    }
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _emailError = null;
      _passwordError = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (_isChecked) {
        await _loginController.saveLoginDetails(email, password, _isChecked);
      }

      BHelperFunction.showToast(
        context: context,
        message: "Login Success!",
        type: ToastificationType.success,
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.code}, ${e.message}");

      String errorMessage = FirebaseAuthErrorHandler.handleAuthException(e);

      // Show the error message in a toast
      BHelperFunction.showToast(
        context: context,
        message: errorMessage,
        type: ToastificationType.error,
      );

      // Clear the form fields & reset state
      setState(() {
        _emailController.clear();
        _passwordController.clear();
        _isChecked = false;

        if (e.code == "invalid-email" || e.code == "user-not-found") {
          _emailError = errorMessage;
        } else if (e.code == "wrong-password" ||
            e.code == "invalid-credential") {
          _passwordError = errorMessage;
        }
      });
    } catch (e) {
      print("General Exception: $e");

      // Show a generic error message
      BHelperFunction.showToast(
        context: context,
        message:
            FirebaseAuthErrorHandler.handleGenericException(e as Exception),
        type: ToastificationType.error,
      );

      // Clear the form fields on any exception
      setState(() {
        _emailController.clear();
        _passwordController.clear();
        _isChecked = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/logos/logo-3-image.png",
                      fit: BoxFit.contain,
                      width: 100,
                      height: 100,
                    ),
                    Text(
                      "Welcome back,",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 245, 71, 32),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Discover limitless Choice and Unmeched Convinence.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFieldWidget(
                            hintText: "Username",
                            textEditingController: _emailController,
                            prefixIcon: Icon(
                              Iconsax.user,
                            ),
                            errorText: _emailError,
                            keyboardType: TextInputType.emailAddress,
                            validator: FormValidators.validateEmail,
                            onChanged: (p0) {
                              setState(() {
                                _emailError = FormValidators.validateEmail(
                                    _emailController.text.trim());
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            hintText: "Password",
                            textEditingController: _passwordController,
                            prefixIcon: Icon(
                              Iconsax.password_check,
                            ),
                            isPasswordField: true,
                            errorText: _passwordError,
                            validator: FormValidators.validatePassword,
                            onChanged: (value) {
                              setState(() {
                                _passwordError =
                                    FormValidators.validatePassword(
                                        _passwordController.text);
                              });
                            },
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                checkColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                activeColor:
                                    const Color.fromARGB(255, 245, 71, 32),
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isChecked = value ?? true;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isChecked = !_isChecked;
                                  });
                                },
                                child: Text(
                                  "Remember Me",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        Get.to(ForgotPasswordScreen()),
                                    child: Text(
                                      "Forgot password?",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 245, 71, 32),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signIn,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                padding: EdgeInsets.all(16),
                                elevation: 5,
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 71, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text("Sign In"),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(RegisterScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(255, 245, 71, 32),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                padding: EdgeInsets.all(16),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        const Color.fromARGB(255, 245, 71, 32),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Create Account"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
