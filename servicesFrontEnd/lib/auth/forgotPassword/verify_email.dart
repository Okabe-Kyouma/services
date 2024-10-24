import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/auth/forgotPassword/new_password.dart';

class PasswordRecovery extends StatelessWidget {
  PasswordRecovery({super.key, required this.email});

  final String email;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Recovery'),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: PopScope(
        canPop: false,
        child: Center(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title:
                                      const Text('Cancel Password Recovery?'),
                                  content: const Text(
                                      'Press Yes to cancel password recovery\nPress No to continue;'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.popUntil(
                                            context,
                                            (route) =>
                                                route.settings.name ==
                                                "/login");
                                      },
                                      child: const Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewPassword(email: email),
                                ),
                              );
                            }
                          },
                          child: const Text('Verify'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
