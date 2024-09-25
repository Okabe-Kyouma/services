import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({super.key, required this.openDashboard});

  final void Function() openDashboard;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void checkIdAndPassword() {
    if (_formKey.currentState!.validate()) {
      // login();
      openDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/logos/login.png'),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Please enter your registred Email id'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                          return "Please enter correct mail id";
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Please enter your password'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return "Please enter correct password";
                        }

                        return null;
                      },
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      checkIdAndPassword();
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
