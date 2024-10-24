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
    void isEmailRegistered(String email) async {
      final response = await findUserByEmail(email);
      print('email_check response-> $response');
      Navigator.pop(context);
      if (response == 202) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PasswordRecovery(email: _emailController.text),
          ),
        );
      } else if (response == 200) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Email-id doesnt exists'),
              content: const Text(
                'The Email-id you have provided doesnt exists in our data please enter correct email-id , or signup!',
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      _emailController.clear();
                      Navigator.of(context).pop();
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
              "Please enter your registered Email-id",
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
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _emailController,
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
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
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
