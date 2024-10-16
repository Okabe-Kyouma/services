import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:services/api/dio_check_existingUser.dart';
import 'package:services/auth/signup/emailVerification/verify_email.dart';
import 'package:services/first_screen.dart';

class Email extends StatelessWidget {
  Email({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

    void main() {
      EmailOTP.config(
          appName: 'Services',
          otpType: OTPType.numeric,
          expiry: 30000,
          emailTheme: EmailTheme.v3,
          otpLength: 6,
          appEmail: 'ayushpal5432@gmail.com');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verification'),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: Image.asset('assets/logos/email.png', fit: BoxFit.cover),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Please enter your Email-id",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: _emailController,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                          return "Please enter correct mail id";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Email-id'),
                        hintText: 'company12@gmail.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: PopScope(
                                  canPop: false,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            });

                        final response =
                            await checkIfEmailExistsInDb(_emailController.text);

                        if (response == 202) {
                          Navigator.of(context).pop();

                          showCupertinoDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('Email-id already exists'),
                                content: const Text(
                                    'The Email-id you have provided already exists,please go to main page to login or enter different email-id!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FirstScreen(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    child: const Text('Go to Login'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Enter another Email-id'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (response == 200) {
                          if (await EmailOTP.sendOTP(
                              email: _emailController.text)) {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyEmail(
                                  email: _emailController.text,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Otp failed send")),
                            );
                          }
                        } else if (response == 500 || response == 404) {
                          Navigator.of(context).pop();

                          showCupertinoDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('Server is Down!'),
                                content: const Text(
                                    'Our server are down!Please try again later!'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Okay'))
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text('Send Otp'),
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
