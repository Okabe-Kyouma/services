import 'package:flutter/material.dart';
import 'package:services/auth/forgotPassword/password_recovery.dart';

class EnterEmail extends StatelessWidget {
  EnterEmail({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Recovery'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                      validator: (value) {
                        if (value == null || !value.contains("@")) {
                          return 'Please enter correct email-id';
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordRecovery(),
                          ),
                        );
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
