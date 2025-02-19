import 'package:bingr/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MailSent extends StatefulWidget {
  final String email;

  const MailSent({Key? key, required this.email}) : super(key: key);

  @override
  State<MailSent> createState() => _MailSentState();
}

class _MailSentState extends State<MailSent>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Reset Email Sent",
          style: TextStyle(
            color: const Color.fromARGB(255, 245, 71, 32),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.tick_circle,
                  size: 100,
                  color: const Color.fromARGB(255, 245, 71, 32),
                ),
                SizedBox(height: 20),
                Text(
                  "Success!",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 245, 71, 32),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "A password reset link has been sent to:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to the login screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.all(16),
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: const Color.fromARGB(255, 245, 71, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Back to Login"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
