import 'package:bingr/common/text_field_widget.dart';
import 'package:bingr/fetures/authentication/login.dart';
import 'package:bingr/util/constant/image_string.dart';
import 'package:bingr/util/helpers/helper_function.dart';
import 'package:bingr/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:toastification/toastification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  register() async {
    try {
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await credentials.user?.updateDisplayName(username);
      await credentials.user?.reload();
      User? user = _auth.currentUser;

      if (user != null) {
        print("User registered: ${user.email}, Username: ${user.displayName}");
      }

      Get.offAll(Wrapper());
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  BImageString.appLogo,
                  fit: BoxFit.contain,
                  width: 100,
                  height: 100,
                ),
                Text(
                  "Welcome to Bingr,",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 245, 71, 32),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Let's create your account",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
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
                            hintText: "Username",
                            textEditingController: _usernameController,
                            prefixIcon: Icon(
                              Iconsax.user,
                            ),
                          ),
                          TextFieldWidget(
                            hintText: "E-Mail",
                            textEditingController: _emailController,
                            prefixIcon: Icon(
                              Iconsax.direct_right,
                            ),
                          ),
                          TextFieldWidget(
                            hintText: "Password",
                            textEditingController: _passwordController,
                            prefixIcon: Icon(
                              Iconsax.password_check,
                            ),
                            isPasswordField: true,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => register(),
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
                              child: Text("Sign Up"),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(255, 245, 71, 32),
                                textStyle: const TextStyle(
                                  fontSize: 18, // Text size
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
                              child: Text("Alredy have account? Login"),
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
}
