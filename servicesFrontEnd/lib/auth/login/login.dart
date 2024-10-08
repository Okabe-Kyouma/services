import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:services/auth/forgotPassword/enter_email.dart';
import 'package:services/widgets/work_profile_created.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void checkIdAndPassword() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => WorkProfileCreated(isWorkProfile: false),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Theme.of(context).colorScheme.onPrimary,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 120),
            child: Center(
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
                              label:
                                  Text('Please enter your registred Email id'),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
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
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[400],
                              borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              checkIdAndPassword();
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Don't remember password?",
                          style: GoogleFonts.montserrat(),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EnterEmail(),
                              ),
                            );
                          },
                          child: const Text('Click Here!'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
