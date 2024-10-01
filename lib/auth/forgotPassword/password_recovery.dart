import 'package:flutter/material.dart';
import 'package:services/auth/forgotPassword/new_password.dart';

class PasswordRecovery extends StatelessWidget {
  PasswordRecovery({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Recovery'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/logos/otp.png', fit: BoxFit.cover),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "We have sent an Otp to your registered Email-id",
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
                        if (value == null || value.length < 6)
                        // !RegExp(r'^\d{12}$').hasMatch(value)
                        {
                          return 'Otp Must be of 6 letters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('OTP'),
                        hintText: 'Enter Otp',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewPassword(),
                          ),
                        );
                      }
                    },
                    child: const Text('Verify'),
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
