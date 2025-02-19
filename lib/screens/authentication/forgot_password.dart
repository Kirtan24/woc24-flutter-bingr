import 'package:bingr/common/widgets/text_field_widget.dart';
import 'package:bingr/screens/authentication/mail_sent.dart';
import 'package:bingr/util/helpers/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toastification/toastification.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  resetPassword() async {
    String email = _emailController.text.trim();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.offAll(MailSent(
        email: email,
      ));
    } catch (e) {
      print(e);
      BHelperFunction.showToast(
        // ignore: use_build_context_synchronously
        context: context,
        message: "Something Went Wrong!",
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: const Color.fromARGB(255, 245, 71, 32),
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
                      "Forgot Password?",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 245, 71, 32),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Please enter your registerd email below we will send you password reset link.",
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
                      child: Column(
                        spacing: 10,
                        children: [
                          TextFieldWidget(
                            hintText: "E-Mail",
                            textEditingController: _emailController,
                            prefixIcon: Icon(
                              Iconsax.user,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => resetPassword(),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(
                                  fontSize: 18, // Text size
                                  fontWeight: FontWeight.bold, // Font weight
                                ),
                                padding: EdgeInsets.all(16),
                                elevation: 5,
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 71, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text("Send"),
                            ),
                          ),
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
}
