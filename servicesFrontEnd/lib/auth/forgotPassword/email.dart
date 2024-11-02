import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/api/dio_findUser.dart';
import 'package:services/auth/forgotPassword/verify_email.dart';

class EnterEmail extends StatelessWidget {
  EnterEmail({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    void main() {
      EmailOTP.config(
          appName: 'Services',
          otpType: OTPType.numeric,
          expiry: 30000,
          emailTheme: EmailTheme.v3,
          otpLength: 6,
          appEmail: 'ayushpal5432@gmail.com');
    }

    void isEmailRegistered(String email) async {
      final response = await findUserByEmail(email);

      Navigator.pop(context);
      if (response == 202) {
        showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: PopScope(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );

        final isEmailSent =
            await EmailOTP.sendOTP(email: _emailController.text);

        Navigator.pop(context);

        if (isEmailSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PasswordRecovery(email: _emailController.text),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Otp failed send")),
          );
        }
      } else if (response == 200) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('EMAIL-ID NOT FOUND'),
              content: const Text(
                  "We couldn’t find that email. Please check it or sign up to continue!"),
              actions: [
                TextButton(
                  onPressed: () {
                    // _emailController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Re-enter'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(context,
                        (route) => route.settings.name == "/firstScreen");
                  },
                  child: const Text('SignUp'),
                ),
              ],
            );
          },
        ).then(
          (_) {
            _emailFocus.unfocus();
          },
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Oops!'),
              content: const Text(
                'Our Servers are Down! Please try again later!',
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _emailFocus.unfocus();
                    },
                    child: const Text('Okay'))
              ],
            );
          },
        ).then(
          (_) {
            _emailFocus.unfocus();
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Recovery'),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Image.asset('assets/logos/email.png', fit: BoxFit.cover),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Please enter your registered Email-id",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryTextTheme.displaySmall?.color),
            ),
            const SizedBox(
              height: 5,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: TextFormField(
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailController,
                       style: TextStyle(color: Theme.of(context).primaryTextTheme.displaySmall?.color),
                      focusNode: _emailFocus,
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                          return "Please enter correct mail id";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                          labelText: 'Email-id',
                          hintText: 'company12@gmail.com',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          )),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _emailFocus.unfocus();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: PopScope(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        );

                        isEmailRegistered(_emailController.text);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    child: const Text(
                      'Send Otp',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
